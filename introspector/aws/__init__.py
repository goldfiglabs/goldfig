import logging
from typing import Any, Callable, Dict, Generator, List, Optional, Tuple

import botocore.exceptions
from botocore.parsers import parse_timestamp
import botocore.session as boto
from dateutil.tz import tzutc
from sqlalchemy.orm import Session

from introspector.aws.fetch import Proxy
from introspector.error import GFInternal, GFError
from introspector.models import ImportJob, ProviderAccount, ProviderCredential

_log = logging.getLogger(__name__)


def _parse_timestamp(value) -> str:
  d = parse_timestamp(value).astimezone(tzutc())
  return d.isoformat()


def _patch_boto(session: boto.Session):
  parser_factory = session.get_component('response_parser_factory')
  parser_factory.set_parser_defaults(timestamp_parser=_parse_timestamp)


def get_boto_session() -> boto.Session:
  session = boto.get_session()
  _patch_boto(session)
  return session


def _create_provider_and_credential(db: Session, proxy: Proxy,
                                    identity) -> ProviderAccount:
  account_id = identity['Account']
  org = proxy.service('organizations')
  try:
    org_resp = org.get('describe_organization')['Organization']
    org_id = org_resp['Id']
  except botocore.exceptions.ClientError as e:
    code = e.response.get('Error', {}).get('Code')
    if code == 'AWSOrganizationsNotInUseException':
      org_id = f'OrgDummy:{account_id}'
    else:
      raise
  provider = ProviderAccount(provider='aws', name=org_id)
  db.add(provider)
  db.flush()
  credential = ProviderCredential(scope=account_id,
                                  principal_uri=identity['Arn'],
                                  config={'from_environment': True})
  credential.provider_id = provider.id
  db.add(credential)
  return provider


def walk_graph(org, graph) -> Generator[Tuple[str, str, Dict], None, None]:
  yield '', 'Organization', org
  ou_paths = graph['organizational_units']
  accounts = graph['accounts']
  for path, entries in ou_paths.items():
    for entry in entries:
      if path == '':
        entry_path = entry['Id']
        typ = 'Root'
      else:
        entry_path = f'{path}/{entry["Id"]}'
        typ = 'OrganizationalUnit'
      yield entry_path, typ, entry
      accounts_at_path = accounts.get(entry_path, [])
      for account in accounts_at_path:
        # No accounts at empty path, only the root is there
        yield f'{entry_path}/{account["Id"]}', 'Account', account


ConfirmAcct = Callable[[Dict], bool]


def build_aws_import_job(db: Session, session: boto.Session,
                         confirm: ConfirmAcct) -> ImportJob:
  proxy = Proxy.build(session)
  sts = session.create_client('sts')
  identity = sts.get_caller_identity()
  provider = _get_or_create_provider(db, proxy, identity, confirm)
  desc = _build_import_job_desc(proxy, identity)
  return ImportJob.create(provider, desc)


def _get_or_create_provider(db: Session, proxy: Proxy, identity: Dict,
                            confirm: ConfirmAcct) -> ProviderAccount:
  org = proxy.service('organizations')
  try:
    org_resp = org.get('describe_organization')['Organization']
    org_id = org_resp['Id']
  except botocore.exceptions.ClientError as e:
    code = e.response.get('Error', {}).get('Code')
    if code == 'AWSOrganizationsNotInUseException':
      org_id = f'OrgDummy:{identity["Account"]}'
    else:
      raise
  account = db.query(ProviderAccount).filter(
      ProviderAccount.provider == 'aws',
      ProviderAccount.name == org_id).one_or_none()
  if account is not None:
    return account
  add = confirm(identity)
  if not add:
    raise GFError('User cancelled')
  return _create_provider_and_credential(db, proxy, identity)


def _build_import_job_desc(proxy: Proxy, identity: Dict) -> Dict:
  account_id = identity['Account']
  org, graph = _build_org_graph(proxy, account_id)
  return {
      'account': {
          'account_id': org['Id'],
          'provider': 'aws'
      },
      'principal': {
          'provider_id': identity['UserId'],
          'provider_uri': identity['Arn']
      },
      'aws_org': org,
      'aws_graph': graph
  }


def _require_resp(tup: Optional[Tuple[str, Dict[str, Any]]]) -> Dict[str, Any]:
  if tup is None:
    raise GFInternal(f'Missing response')
  else:
    return tup[1]


def _build_org_graph(proxy: Proxy, account_id: str):
  org = proxy.service('organizations')
  try:
    org_resp = org.get('describe_organization')['Organization']
  except botocore.exceptions.ClientError as e:
    code = e.response.get('Error', {}).get('Code')
    if code == 'AWSOrganizationsNotInUseException':
      org_id = f'OrgDummy:{account_id}'

      org_resp = {
          'Id':
          org_id,
          "Arn":
          f"arn:aws:organizations::{account_id}:organization/{org_id}",
          "MasterAccountId":
          account_id,
          "MasterAccountArn":
          f"arn:aws:organizations::{account_id}:account/{org_id}/{account_id}",
      }
      root_id = 'r-dummy'
      root = {
          "Id": root_id,
          "Arn":
          f"arn:aws:organizations::{account_id}:root/{org_id}/{root_id}",
          "Name": "Root",
          "PolicyTypes": []
      }
      account = {
          "Id":
          account_id,
          "Arn":
          f"arn:aws:organizations::{account_id}:account/{org_id}/{account_id}"
      }
      return org_resp, {
          'accounts': {
              root_id: [account]
          },
          'organizational_units': {
              '': [root]
          }
      }
    else:
      raise
  roots_resp = _require_resp(org.list('list_roots'))
  roots = roots_resp['Roots']
  accounts = {}
  organizational_units = {}

  def build_graph(parent_id: str, path: List[str]):
    accounts_resp = _require_resp(
        org.list('list_accounts_for_parent', ParentId=parent_id))
    next_path = [*path, parent_id]
    path_str = '/'.join(next_path)
    accounts[path_str] = accounts_resp['Accounts']
    organizational_units_resp = _require_resp(
        org.list('list_organizational_units_for_parent', ParentId=parent_id))
    ous = organizational_units_resp['OrganizationalUnits']
    if len(ous) > 0:
      organizational_units[path_str] = ous
      for ou in ous:
        build_graph(parent_id=ou['Id'], path=next_path)

  organizational_units[''] = roots
  for root in roots:
    build_graph(root['Id'], [])
  return org_resp, {
      'accounts': accounts,
      'organizational_units': organizational_units
  }


def load_boto_session_from_config(config: Dict[str, Any]) -> boto.Session:
  if config.get('from_environment', False):
    session = boto.get_session()
  else:
    access_key = config['access_key']
    secret_key = config['secret_key']
    session = boto.Session()
    session.set_credentials(access_key, secret_key)
  _patch_boto(session)
  return session


def load_boto_session(provider_credential: ProviderCredential) -> boto.Session:
  config = provider_credential.config
  return load_boto_session_from_config(config)


def account_paths_for_import(
    db: Session,
    import_job: ImportJob) -> List[Tuple[str, ProviderCredential]]:
  creds = db.query(ProviderCredential).filter(
      ProviderCredential.provider_id == import_job.provider_account_id).all()

  def find_credential(account_id: str) -> ProviderCredential:
    return next(cred for cred in creds if cred.scope == account_id)

  account_paths = import_job.aws_config.graph.accounts
  results = []
  for path, accounts in account_paths.items():
    for account in accounts:
      try:
        cred = find_credential(account.id)
        results.append((f'{path}/{cred.scope}', cred))
      except StopIteration:
        # If we don't have credentials, don't import it
        _log.info(f'Skipping account id {account.id}, no credentials')
        continue
  return results