-- Get all statement effects from documents:
--   SELECT document->'Statement'->0->'Effect' FROM aws_iam_policyversion;

DROP MATERIALIZED VIEW IF EXISTS aws_iam_policyversion CASCADE;

CREATE MATERIALIZED VIEW aws_iam_policyversion AS
WITH cte_resourceattrs AS (
    SELECT
        resource.id,
        resource.uri,
        resource.provider_account_id,
        resource_attribute.resource_id,
        LOWER(resource_attribute.attr_name) AS attr_name,
        resource_attribute.attr_value
    FROM
        RESOURCE
        INNER JOIN provider_account ON resource.provider_account_id = provider_account.id
        INNER JOIN resource_attribute ON resource.id = resource_attribute.resource_id
    WHERE
        resource.provider_type = 'PolicyVersion'
        AND provider_account.provider = 'aws'
        AND resource_attribute.type = 'provider'
)
SELECT DISTINCT
    _key.resource_id,
    _key.uri,
    _key.provider_account_id,
    (TO_TIMESTAMP(_clsc_1.attr_value #>> '{}', 'YYYY-MM-DD"T"HH24:MI:SS')::timestamp at time zone '00:00') AS "createdate",
    (_clsc_2.attr_value::jsonb) AS "document",
    (_clsc_3.attr_value::boolean) AS "isdefaultversion",
    (_clsc_4.attr_value #>> '{}') AS "versionid"
FROM ( SELECT DISTINCT
        uri,
        resource_id,
        id,
        provider_account_id
    FROM
        cte_resourceattrs) _key
    LEFT JOIN cte_resourceattrs AS _clsc_1 ON _clsc_1.uri = _key.uri
        AND _clsc_1.resource_id = _key.resource_id
        AND _clsc_1.id = _key.id
        AND _clsc_1.attr_name = 'createdate'
    LEFT JOIN cte_resourceattrs AS _clsc_2 ON _clsc_2.uri = _key.uri
        AND _clsc_2.resource_id = _key.resource_id
        AND _clsc_2.id = _key.id
        AND _clsc_2.attr_name = 'document'
    LEFT JOIN cte_resourceattrs AS _clsc_3 ON _clsc_3.uri = _key.uri
        AND _clsc_3.resource_id = _key.resource_id
        AND _clsc_3.id = _key.id
        AND _clsc_3.attr_name = 'isdefaultversion'
    LEFT JOIN cte_resourceattrs AS _clsc_4 ON _clsc_4.uri = _key.uri
        AND _clsc_4.resource_id = _key.resource_id
        AND _clsc_4.id = _key.id
        AND _clsc_4.attr_name = 'versionid' WITH NO DATA;

REFRESH MATERIALIZED VIEW aws_iam_policyversion;

COMMENT ON MATERIALIZED VIEW aws_iam_policyversion IS 'AWS IAM policy versions and their associated attributes.'
