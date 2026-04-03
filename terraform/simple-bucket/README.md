# simple-bucket

Tier-2 app module. Composes `s3_bucket` and `lifecycle_config` for a standard single-account bucket. The bucket policy grants the owning account root full access. Accepts a map of bucket configurations so multiple buckets can be managed in a single module call.

