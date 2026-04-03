variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "create_lifecycle_rule" {
  description = "Whether to create a lifecycle expiration rule on this bucket."
  type        = bool
  default     = false
}

variable "lifecycle_rule_name" {
  description = "Unique identifier for the lifecycle rule."
  type        = string
  default     = "default"
}

variable "lifecycle_prefix" {
  description = "Object key prefix to which the lifecycle rule applies. Use an empty string to target all objects."
  type        = string
  default     = ""
}

variable "lifecycle_days" {
  description = "Number of days after which objects matching the prefix will expire."
  type        = number
  default     = 30

  validation {
    condition     = var.lifecycle_days > 0
    error_message = "lifecycle_days must be a positive integer."
  }
}
