# simple-bucket

Tier-2 app module. Composes `s3_bucket`, `lifecycle_config`, and optionally `access_point` for a standard single-account bucket. The bucket policy grants the owning account root full access. Accepts a map of bucket configurations so multiple buckets can be managed in a single module call.

## VPC-scoped access

Set `vpc_id` on any bucket entry to create a VPC-restricted S3 access point. When set, an `aws_s3_access_point` is created with `vpc_configuration` tied to that VPC — only traffic originating from the VPC can use the access point. Leave `vpc_id` empty (or omit it) to skip access point creation.

