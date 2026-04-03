region    = "us-east-1"
env       = "stg"
workspace = "aws-s3-platform-stg"

simple_buckets = {
  "app-data" = {
    bucket_name           = "stg-app-data-bucket"
    bucket_ownership      = "BucketOwnerEnforced"
    enable_eventbridge    = false
    directories           = ["uploads/", "processed/"]
    create_lifecycle_rule = true
    lifecycle_rule_name   = "expire-processed"
    lifecycle_prefix      = "processed/"
    lifecycle_days        = 30
  }
}

# Grant a role in another AWS account read/write access to this bucket.
# Replace CONSUMER_ACCOUNT_ID and the role name with real values.
cross_account_buckets = {
  "shared-exports" = {
    bucket_name            = "stg-shared-exports-bucket"
    bucket_ownership       = "BucketOwnerEnforced"
    cross_account_role_arn = "arn:aws:iam::CONSUMER_ACCOUNT_ID:role/consumer-read-role"
    enable_eventbridge     = false
    create_lifecycle_rule  = true
    lifecycle_rule_name    = "expire-exports"
    lifecycle_prefix       = ""
    lifecycle_days         = 90
  }
}

# Versioned bucket replicated to a bucket in a separate account/region.
# Replace DESTINATION_ACCOUNT_ID and bucket names with real values.
replication_buckets = {
  "critical-data" = {
    bucket_name                     = "stg-critical-data-bucket"
    bucket_ownership                = "BucketOwnerEnforced"
    enable_versioning               = true
    enable_replication              = true
    replication_destination_buckets = ["stg-critical-data-bucket-replica"]
    replication_destinations        = [""]
    destination_account             = ["DESTINATION_ACCOUNT_ID"]
  }
}
