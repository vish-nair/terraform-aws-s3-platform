variable "region" {
  description = "AWS region for all resources."
  type        = string
}

variable "env" {
  description = "Environment name (e.g. dev, stg, prd)."
  type        = string
}

variable "workspace" {
  description = "Terraform workspace or CI/CD pipeline name. Used for tagging."
  type        = string
}

variable "department" {
  description = "Department or team owning these resources. Used for tagging."
  type        = string
  default     = "platform"
}

variable "cost_center" {
  description = "Cost center code for billing attribution. Used for tagging."
  type        = string
  default     = ""
}

variable "backup_type" {
  description = "Backup strategy for tagging (e.g. daily, weekly, none)."
  type        = string
  default     = "none"
}

variable "simple_buckets" {
  description = "Configuration for simple S3 buckets with optional lifecycle expiration."
  type = map(object({
    bucket_name           = string
    bucket_ownership      = string
    enable_eventbridge    = bool
    directories           = list(string)
    create_lifecycle_rule = bool
    lifecycle_rule_name   = string
    lifecycle_prefix      = string
    lifecycle_days        = number
    vpc_id                = optional(string, "")
  }))
  default = {}
}

variable "cross_account_buckets" {
  description = "Configuration for S3 buckets with cross-account access policies."
  type = map(object({
    bucket_name            = string
    bucket_ownership       = string
    cross_account_role_arn = string
    enable_eventbridge     = bool
    create_lifecycle_rule  = bool
    lifecycle_rule_name    = string
    lifecycle_prefix       = string
    lifecycle_days         = number
  }))
  default = {}
}

variable "replication_buckets" {
  description = "Configuration for S3 buckets with versioning and cross-account/cross-region replication."
  type = map(object({
    bucket_name                     = string
    bucket_ownership                = string
    enable_versioning               = bool
    enable_replication              = bool
    replication_destination_buckets = list(string)
    replication_destinations        = list(string)
    destination_account             = list(string)
  }))
  default = {}
}
