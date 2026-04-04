region    = "us-east-1"
env       = "dev"
workspace = "aws-s3-platform-dev"

simple_buckets = {
  "app-data" = {
    bucket_name           = "dev-app-data-bucket"
    bucket_ownership      = "BucketOwnerEnforced"
    enable_eventbridge    = false
    directories           = ["uploads/", "processed/"]
    create_lifecycle_rule = true
    lifecycle_rule_name   = "expire-processed"
    lifecycle_prefix      = "processed/"
    lifecycle_days        = 30
    vpc_id                = "vpc-0abc123456789def0"
  }
}

cross_account_buckets = {}
replication_buckets   = {}
