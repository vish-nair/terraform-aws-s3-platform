output "access_point_arn" {
  description = "ARN of the S3 access point, if created."
  value       = var.create_access_point ? aws_s3_access_point.this[0].arn : null
}

output "access_point_alias" {
  description = "Alias hostname of the S3 access point, if created."
  value       = var.create_access_point ? aws_s3_access_point.this[0].alias : null
}
