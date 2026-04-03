# iam

Creates an IAM role and inline policy for S3 access. Used for replication roles, cross-service access, or OIDC web identity federation. Set `create_iam_role = false` to skip resource creation (useful when iterating over a mixed map where some entries don't need IAM).

