variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "bucket_policy" {
  description = "JSON-encoded bucket policy document. Leave empty to skip attaching a bucket policy."
  type        = string
  default     = ""
}

variable "bucket_ownership" {
  description = "Object ownership rule. One of: BucketOwnerPreferred, ObjectWriter, BucketOwnerEnforced."
  type        = string
  default     = "BucketOwnerEnforced"

  validation {
    condition     = contains(["BucketOwnerPreferred", "ObjectWriter", "BucketOwnerEnforced"], var.bucket_ownership)
    error_message = "bucket_ownership must be one of: BucketOwnerPreferred, ObjectWriter, BucketOwnerEnforced."
  }
}

variable "enable_eventbridge" {
  description = "Enable EventBridge notifications for all S3 events on this bucket."
  type        = bool
  default     = false
}

variable "directories" {
  description = "List of directory prefixes (keys ending in /) to pre-create as empty objects."
  type        = list(string)
  default     = []
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning. Required when using cross-region replication."
  type        = bool
  default     = false
}

variable "sqs_notification_queue_arns" {
  description = "List of SQS queue ARNs to receive s3:ObjectCreated notifications."
  type        = list(string)
  default     = []
}

variable "kms_key_arn" {
  description = "ARN of a KMS key for server-side encryption (SSE-KMS). Leave empty to skip KMS encryption (AWS-managed SSE-S3 still applies at the account level)."
  type        = string
  default     = ""
}
