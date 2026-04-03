variable "create_iam_role" {
  description = "Whether to create the IAM role and policy. Set to false to skip IAM resource creation."
  type        = bool
  default     = false
}

variable "bucket_name" {
  description = "Name of the S3 bucket. Used to name the IAM role and policy."
  type        = string
}

variable "assume_role_policy" {
  description = "JSON-encoded trust policy document for the IAM role. Required when create_iam_role is true."
  type        = string
  default     = ""
}

variable "policy" {
  description = "JSON-encoded permissions policy document to attach to the IAM role. Required when create_iam_role is true."
  type        = string
  default     = ""
}
