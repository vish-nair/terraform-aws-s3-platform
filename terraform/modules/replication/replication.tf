resource "aws_s3_bucket_replication_configuration" "replication" {
  count  = var.enable_versioning && var.enable_replication ? 1 : 0
  bucket = var.bucket_name
  role   = var.replication_role

  dynamic "rule" {
    for_each = var.replication_destinations

    content {
      id       = "rule-id-${rule.key}"
      status   = "Enabled"
      priority = rule.key

      filter {
        prefix = rule.value
      }

      destination {
        bucket  = "arn:aws:s3:::${var.replication_destination_buckets[rule.key]}"
        account = var.destination_account[rule.key]

        replication_time {
          status = "Enabled"
          time {
            minutes = 15
          }
        }
        metrics {
          event_threshold {
            minutes = 15
          }
          status = "Enabled"
        }

        access_control_translation {
          owner = "Destination"
        }
      }
      delete_marker_replication {
        status = "Disabled"
      }
    }
  }
}
