# replication-bucket

Tier-2 app module. Composes `s3_bucket`, `iam`, and `replication` for a versioned bucket with cross-account or cross-region replication. The IAM role and replication configuration are only created for entries where `enable_replication = true`, so a mixed map (some replicated, some not) is valid.

