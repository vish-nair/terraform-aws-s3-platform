# Access Point config for S3 Bucket

resource "aws_s3_access_point" "this" {
  count  = var.create_access_point ? 1 : 0
  name   = "access-point-${var.bucket_name}"
  bucket = var.bucket_name
  policy = var.access_point_policy != "" ? var.access_point_policy : null

  dynamic "vpc_configuration" {
    for_each = var.vpc_id != "" ? [1] : []
    content {
      vpc_id = var.vpc_id
    }
  }
}
