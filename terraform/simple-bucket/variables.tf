variable "s3_buckets" {
  description = "Map of S3 bucket configurations. Each key becomes a unique Terraform resource identifier."
  type = map(object({
    bucket_name           = string
    bucket_ownership      = string
    enable_eventbridge    = bool
    directories           = list(string)
    create_lifecycle_rule = bool
    lifecycle_rule_name   = string
    lifecycle_prefix      = string
    lifecycle_days        = number
  }))
}

variable "region" {
  description = "AWS region for these resources."
  type        = string
}

variable "env" {
  description = "Environment name (e.g. dev, stg, prd)."
  type        = string
}

variable "workspace" {
  description = "Terraform workspace or CI/CD pipeline name."
  type        = string
}
