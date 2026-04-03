resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "directory" {
  count      = length(var.directories)
  bucket     = aws_s3_bucket.this.bucket
  key        = var.directories[count.index]
  source     = "/dev/null"
  depends_on = [aws_s3_bucket.this]
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = var.bucket_ownership
  }
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.bucket_policy != "" ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  policy = var.bucket_policy
}

resource "aws_s3_bucket_notification" "this" {
  bucket      = aws_s3_bucket.this.bucket
  eventbridge = var.enable_eventbridge

  dynamic "queue" {
    for_each = var.sqs_notification_queue_arns
    content {
      queue_arn = queue.value
      events    = ["s3:ObjectCreated:Put", "s3:ObjectCreated:Post"]
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.kms_key_arn != "" ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}
