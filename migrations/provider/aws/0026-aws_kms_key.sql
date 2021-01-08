-- migrate:up

CREATE TABLE IF NOT EXISTS aws_kms_key (
  _id INTEGER NOT NULL PRIMARY KEY,
  uri TEXT NOT NULL,
  provider_account_id INTEGER NOT NULL,awsaccountid TEXT,
  keyid TEXT,
  arn TEXT,
  creationdate TIMESTAMP WITH TIME ZONE,
  enabled BOOLEAN,
  description TEXT,
  keyusage TEXT,
  keystate TEXT,
  deletiondate TIMESTAMP WITH TIME ZONE,
  validto TIMESTAMP WITH TIME ZONE,
  origin TEXT,
  customkeystoreid TEXT,
  cloudhsmclusterid TEXT,
  expirationmodel TEXT,
  keymanager TEXT,
  customermasterkeyspec TEXT,
  encryptionalgorithms JSONB,
  signingalgorithms JSONB,
  tags JSONB,
  keyrotationenabled BOOLEAN,
  policy JSONB,
  _account_id INTEGER,
    FOREIGN KEY (_account_id) REFERENCES aws_organizations_account (_id) ON DELETE SET NULL,
  FOREIGN KEY (provider_account_id) REFERENCES public.provider_account (id) ON DELETE CASCADE,
  FOREIGN KEY (_id) REFERENCES public.resource (id) ON DELETE CASCADE
);

COMMENT ON TABLE aws_kms_key IS 'kms Key resources and their associated attributes.';

ALTER TABLE aws_kms_key ENABLE ROW LEVEL SECURITY;
CREATE POLICY read_aws_kms_key ON aws_kms_key
USING (
  current_user = 'goldfig_ro'
  OR
  provider_account_id = current_setting('gf.provider_account_id', true)::int
);
