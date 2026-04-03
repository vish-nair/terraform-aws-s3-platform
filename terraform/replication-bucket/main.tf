module "s3_bucket" {
  source   = "../../modules/s3_bucket"
  for_each = var.s3_buckets

  bucket_name       = each.value.bucket_name
  bucket_ownership  = each.value.bucket_ownership
  bucket_policy     = data.aws_iam_policy_document.bucket_policy[each.key].json
  enable_versioning = each.value.enable_versioning
}

# IAM role for replication — only created for buckets with replication enabled
module "iam" {
  source   = "../../modules/iam"
  for_each = { for k, v in var.s3_buckets : k => v if v.enable_replication }

  bucket_name        = each.value.bucket_name
  create_iam_role    = true
  policy             = data.aws_iam_policy_document.replication_policy[each.key].json
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[each.key].json
}

module "replication" {
  source   = "../../modules/replication"
  for_each = { for k, v in var.s3_buckets : k => v if v.enable_replication }

  bucket_name                     = each.value.bucket_name
  enable_versioning               = each.value.enable_versioning
  enable_replication              = each.value.enable_replication
  replication_destination_buckets = each.value.replication_destination_buckets
  replication_destinations        = each.value.replication_destinations
  destination_account             = each.value.destination_account
  replication_role                = module.iam[each.key].role_arn

  depends_on = [module.iam, module.s3_bucket]
}
