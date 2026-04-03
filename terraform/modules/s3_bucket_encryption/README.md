# s3_bucket_encryption

Applies SSE-KMS encryption to an existing S3 bucket using a customer-managed KMS key. Use this module when encryption needs to be managed independently of bucket creation (e.g. the KMS key is created in a separate stack). For most cases, pass `kms_key_arn` directly to the `s3_bucket` module instead.

