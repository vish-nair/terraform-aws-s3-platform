variable "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the S3 bucket"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}