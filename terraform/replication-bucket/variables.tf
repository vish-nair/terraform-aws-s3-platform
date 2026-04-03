variable "s3_buckets" {
  description = "Map of S3 bucket configurations. Each key becomes a unique Terraform resource identifier."
  type = map(object({
    bucket_name                     = string
    bucket_ownership                = string
    enable_versioning               = bool
    enable_replication              = bool
    replication_destination_buckets = list(string)
    replication_destinations        = list(string)
    destination_account             = list(string)
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
