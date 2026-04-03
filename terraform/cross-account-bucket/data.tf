data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "bucket_policy" {
  for_each = var.s3_buckets

  # Allow the owning account full access
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

  # Grant scoped access to a role or account in a different AWS account
  statement {
    sid    = "AllowCrossAccountAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [each.value.cross_account_role_arn]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${each.value.bucket_name}",
      "arn:aws:s3:::${each.value.bucket_name}/*",
    ]
  }
}
