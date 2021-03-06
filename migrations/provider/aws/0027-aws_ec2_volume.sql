-- migrate:up

CREATE TABLE IF NOT EXISTS aws_ec2_volume (
  _id INTEGER NOT NULL PRIMARY KEY,
  uri TEXT NOT NULL,
  provider_account_id INTEGER NOT NULL,attachments JSONB,
  availabilityzone TEXT,
  createtime TIMESTAMP WITH TIME ZONE,
  encrypted BOOLEAN,
  kmskeyid TEXT,
  outpostarn TEXT,
  size INTEGER,
  snapshotid TEXT,
  state TEXT,
  volumeid TEXT,
  iops INTEGER,
  tags JSONB,
  volumetype TEXT,
  fastrestored BOOLEAN,
  multiattachenabled BOOLEAN,
  _account_id INTEGER,
    FOREIGN KEY (_account_id) REFERENCES aws_organizations_account (_id) ON DELETE SET NULL,
  FOREIGN KEY (provider_account_id) REFERENCES public.provider_account (id) ON DELETE CASCADE,
  FOREIGN KEY (_id) REFERENCES public.resource (id) ON DELETE CASCADE
);

COMMENT ON TABLE aws_ec2_volume IS 'ec2 Volume resources and their associated attributes.';

ALTER TABLE aws_ec2_volume ENABLE ROW LEVEL SECURITY;
CREATE POLICY read_aws_ec2_volume ON aws_ec2_volume
USING (
  current_user = 'introspector_ro'
  OR
  provider_account_id = current_setting('introspector.provider_account_id', true)::int
);

