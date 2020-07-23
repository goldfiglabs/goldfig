DROP MATERIALIZED VIEW IF EXISTS aws_organizations_root CASCADE;

CREATE MATERIALIZED VIEW aws_organizations_root AS
WITH attrs AS (
  SELECT
    R.id,
    LOWER(RA.attr_name) AS attr_name,
    RA.attr_value
  FROM
    resource AS R
    INNER JOIN resource_attribute AS RA
      ON RA.resource_id = R.id
  WHERE
    RA.type = 'provider'
)
SELECT
  R.id AS resource_id,
  R.uri,
  R.provider_account_id,
  id.attr_value #>> '{}' AS id,
  arn.attr_value #>> '{}' AS arn,
  name.attr_value #>> '{}' AS name,
  policytypes.attr_value::jsonb AS policytypes,
  servicecontrolpolicies.attr_value::jsonb AS servicecontrolpolicies,
  tagpolicies.attr_value::jsonb AS tagpolicies
  
FROM
  resource AS R
  INNER JOIN provider_account AS PA
    ON PA.id = R.provider_account_id
  LEFT JOIN attrs AS id
    ON id.id = R.id
    AND id.attr_name = 'id'
  LEFT JOIN attrs AS arn
    ON arn.id = R.id
    AND arn.attr_name = 'arn'
  LEFT JOIN attrs AS name
    ON name.id = R.id
    AND name.attr_name = 'name'
  LEFT JOIN attrs AS policytypes
    ON policytypes.id = R.id
    AND policytypes.attr_name = 'policytypes'
  LEFT JOIN attrs AS servicecontrolpolicies
    ON servicecontrolpolicies.id = R.id
    AND servicecontrolpolicies.attr_name = 'servicecontrolpolicies'
  LEFT JOIN attrs AS tagpolicies
    ON tagpolicies.id = R.id
    AND tagpolicies.attr_name = 'tagpolicies'
  WHERE
  PA.provider = 'aws'
  AND LOWER(R.provider_type) = 'root'
WITH NO DATA;

REFRESH MATERIALIZED VIEW aws_organizations_root;

COMMENT ON MATERIALIZED VIEW aws_organizations_root IS 'organizations root resources and their associated attributes.';