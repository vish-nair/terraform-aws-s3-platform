resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = var.bucket_name

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}