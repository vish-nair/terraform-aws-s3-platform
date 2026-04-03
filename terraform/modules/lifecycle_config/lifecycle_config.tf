# Lifecycle rule for objects and folders

resource "aws_s3_bucket_lifecycle_configuration" "bucket_with_lifecycle" {
  count  = var.create_lifecycle_rule ? 1 : 0
  bucket = var.bucket_name
  rule {
    id = "${var.lifecycle_rule_name}-lifecycle-rule"
    filter {
      prefix = var.lifecycle_prefix
    }
    expiration {
      days = var.lifecycle_days
    }
    status = "Enabled"
  }
}
