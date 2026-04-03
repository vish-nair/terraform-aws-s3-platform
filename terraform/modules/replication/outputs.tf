output "replication_configuration_id" {
  description = "ID of the S3 replication configuration, if created."
  value       = var.enable_versioning && var.enable_replication ? aws_s3_bucket_replication_configuration.replication[0].id : null
}
