variable "bucket_name" {
  description = "Name of the source S3 bucket."
  type        = string
}

variable "enable_versioning" {
  description = "Whether versioning is enabled on the source bucket. Both versioning and enable_replication must be true for replication to be configured."
  type        = bool
  default     = false
}

variable "enable_replication" {
  description = "Whether to enable cross-region or cross-account replication."
  type        = bool
  default     = false
}

variable "replication_role" {
  description = "ARN of the IAM role that S3 assumes to replicate objects."
  type        = string
  default     = ""
}

variable "replication_destinations" {
  description = "List of object key prefixes to filter objects per replication rule. Use an empty string for all objects. Must be the same length as replication_destination_buckets."
  type        = list(string)
  default     = []
}

variable "replication_destination_buckets" {
  description = "List of destination bucket names (without ARN prefix) for each replication rule. Indexed to match replication_destinations."
  type        = list(string)
  default     = []
}

variable "destination_account" {
  description = "List of destination AWS account IDs, one per replication rule. Used for cross-account ownership override. Indexed to match replication_destinations."
  type        = list(string)
  default     = []
}
