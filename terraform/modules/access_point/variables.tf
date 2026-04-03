variable "bucket_name" {
  description = "Name of the S3 bucket to associate the access point with."
  type        = string
}

variable "create_access_point" {
  description = "Whether to create the S3 access point."
  type        = bool
  default     = true
}

variable "access_point_policy" {
  description = "JSON-encoded policy for the access point. Leave empty for no access point policy."
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID to restrict access point access to a specific VPC. Leave empty to allow access from any network."
  type        = string
  default     = ""
}
