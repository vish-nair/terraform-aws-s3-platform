provider "aws" {
  region = var.region
  default_tags {
    tags = {
      managed-by  = "terraform"
      environment = var.env
      workspace   = var.workspace
      department  = var.department
      cost-center = var.cost_center
      backup      = var.backup_type != "" ? var.backup_type : "none"
    }
  }
}

# Simple S3 buckets with optional lifecycle expiration.
# Present in all environments.
module "simple_bucket" {
  source = "../simple-bucket"

  env        = var.env
  region     = var.region
  workspace  = var.workspace
  s3_buckets = var.simple_buckets
}

# Buckets that grant scoped access to a role or account in another AWS account.
# Only deployed to stg and prd where cross-account integrations are active.
module "cross_account_bucket" {
  count  = contains(["stg", "prd"], var.env) ? 1 : 0
  source = "../cross-account-bucket"

  env        = var.env
  region     = var.region
  workspace  = var.workspace
  s3_buckets = var.cross_account_buckets
}

# Buckets with versioning and cross-account/cross-region replication.
# Only deployed to stg and prd.
module "replication_bucket" {
  count  = contains(["stg", "prd"], var.env) ? 1 : 0
  source = "../replication-bucket"

  env        = var.env
  region     = var.region
  workspace  = var.workspace
  s3_buckets = var.replication_buckets
}
