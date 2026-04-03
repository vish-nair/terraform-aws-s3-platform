module "s3_bucket" {
  source   = "../../modules/s3_bucket"
  for_each = var.s3_buckets

  bucket_name        = each.value.bucket_name
  bucket_ownership   = each.value.bucket_ownership
  bucket_policy      = data.aws_iam_policy_document.bucket_policy[each.key].json
  enable_eventbridge = each.value.enable_eventbridge
  directories        = each.value.directories
}

module "lifecycle_config" {
  source   = "../../modules/lifecycle_config"
  for_each = var.s3_buckets

  bucket_name           = each.value.bucket_name
  create_lifecycle_rule = each.value.create_lifecycle_rule
  lifecycle_rule_name   = each.value.lifecycle_rule_name
  lifecycle_prefix      = each.value.lifecycle_prefix
  lifecycle_days        = each.value.lifecycle_days
}
