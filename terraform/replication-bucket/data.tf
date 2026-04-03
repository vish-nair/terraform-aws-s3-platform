data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "bucket_policy" {
  for_each = var.s3_buckets

  statement {
    sid    = "AllowAccountRootAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${each.value.bucket_name}",
      "arn:aws:s3:::${each.value.bucket_name}/*",
    ]
  }
}

# Replication permissions: read from source, write to destination
data "aws_iam_policy_document" "replication_policy" {
  for_each = { for k, v in var.s3_buckets : k => v if v.enable_replication }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]
    resources = [
      "arn:aws:s3:::${each.value.bucket_name}",
      "arn:aws:s3:::${each.value.bucket_name}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ObjectOwnerOverrideToBucketOwner",
      "s3:GetObjectVersionTagging",
      "s3:ReplicateTags",
    ]
    resources = [for bucket in each.value.replication_destination_buckets : "arn:aws:s3:::${bucket}/*"]
  }
}

# Trust policy: allow S3 service to assume the replication role
data "aws_iam_policy_document" "assume_role_policy" {
  for_each = { for k, v in var.s3_buckets : k => v if v.enable_replication }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
