region    = "us-west-2"
env       = "prd"
workspace = "aws-s3-platform-prd"

simple_buckets = {
  "app-data" = {
    bucket_name           = "prd-app-data-bucket"
    bucket_ownership      = "BucketOwnerEnforced"
    enable_eventbridge    = false
    directories           = ["uploads/", "processed/"]
    create_lifecycle_rule = true
    lifecycle_rule_name   = "expire-processed"
    lifecycle_prefix      = "processed/"
    lifecycle_days        = 30
    vpc_id                = ""
  }
}

cross_account_buckets = {
  "shared-exports" = {
    bucket_name            = "prd-shared-exports-bucket"
    bucket_ownership       = "BucketOwnerEnforced"
    cross_account_role_arn = "arn:aws:iam::CONSUMER_ACCOUNT_ID:role/consumer-read-role"
    enable_eventbridge     = false
    create_lifecycle_rule  = true
    lifecycle_rule_name    = "expire-exports"
    lifecycle_prefix       = ""
    lifecycle_days         = 180
  }
}

replication_buckets = {
  "critical-data" = {
    bucket_name                     = "prd-critical-data-bucket"
    bucket_ownership                = "BucketOwnerEnforced"
    enable_versioning               = true
    enable_replication              = true
    replication_destination_buckets = ["prd-critical-data-bucket-replica"]
    replication_destinations        = [""]
    destination_account             = ["DESTINATION_ACCOUNT_ID"]
  }
}
