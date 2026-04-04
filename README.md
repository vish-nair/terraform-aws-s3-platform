# terraform-aws-s3-platform

[![Terraform Validate](https://github.com/vish-nair/terraform-aws-s3-platform/actions/workflows/validate.yml/badge.svg)](https://github.com/vish-nair/terraform-aws-s3-platform/actions/workflows/validate.yml)
[![tfsec](https://github.com/vish-nair/terraform-aws-s3-platform/actions/workflows/tfsec.yml/badge.svg)](https://github.com/vish-nair/terraform-aws-s3-platform/actions/workflows/tfsec.yml)

A 3-tier Terraform pattern for managing multiple S3 buckets across environments and applications from a single repository. Designed to be forked and adapted — the structure scales from a handful of buckets to dozens without the root configuration growing unmanageable.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  Tier 3 — Root (terraform/app/)                             │
│  Provider config, default tags, env-conditional wiring      │
└────────────────────────┬────────────────────────────────────┘
                         │ calls
     ┌───────────────────┼───────────────────┐
     ▼                   ▼                   ▼
┌─────────────┐  ┌──────────────────┐  ┌──────────────────┐
│   Tier 2    │  │     Tier 2       │  │     Tier 2       │
│   simple-   │  │  cross-account-  │  │  replication-    │
│   bucket    │  │    bucket        │  │    bucket        │
└──────┬──────┘  └────────┬─────────┘  └────────┬─────────┘
       │                  │                      │ calls
       └──────────────────┼──────────────────────┘
                          │
     ┌────────────────────┼────────────────────────────────┐
     ▼                    ▼              ▼                  ▼
┌──────────┐  ┌──────────────────┐  ┌────────┐  ┌──────────────┐
│   Tier 1 │  │      Tier 1      │  │ Tier 1 │  │   Tier 1     │
│ s3_bucket│  │ lifecycle_config │  │  iam   │  │ replication  │
└──────────┘  └──────────────────┘  └────────┘  └──────────────┘
```

| Tier | Location | Purpose |
|------|----------|---------|
| 1 — Primitive modules | `terraform/modules/` | Single-concern, reusable building blocks |
| 2 — App modules | `terraform/<pattern>/` | Compose primitives for a specific use case |
| 3 — Root | `terraform/app/` | Provider config, tagging, env-conditional wiring |

**Why three tiers?** Tier 1 stays generic and testable in isolation. Tier 2 encapsulates the policy and IAM logic for each bucket pattern so the root stays flat. Adding a new bucket type means adding a new Tier-2 directory — the root gets one new `module` block, not a wall of resource config.

## Tier-1 Modules

| Module | Description |
|--------|-------------|
| `modules/s3_bucket` | Core bucket resource — ownership controls, public access block, optional versioning, SQS/EventBridge notifications, optional KMS encryption |
| `modules/lifecycle_config` | Single-rule object expiration lifecycle policy |
| `modules/iam` | IAM role + policy for S3 access (replication, cross-service, OIDC) |
| `modules/replication` | Cross-account/cross-region replication with RTC and metrics |
| `modules/access_point` | VPC-scoped S3 access point |
| `modules/s3_bucket_encryption` | Standalone KMS encryption resource for managing encryption separately from the bucket |

## Tier-2 App Modules

### `simple-bucket`
Basic S3 bucket with an account-root bucket policy and optional lifecycle expiration. Supports VPC-scoped access via an S3 access point — set `vpc_id` on any bucket entry to restrict access to a specific VPC. The starting point for most use cases.

### `cross-account-bucket`
Extends `simple-bucket` with a second policy statement granting a role or account in another AWS account scoped `GetObject`, `PutObject`, and `ListBucket` access.

### `replication-bucket`
Versioned bucket with cross-account/cross-region replication. Creates an IAM role with the correct replication permissions and wires it to the replication configuration. Uses RTC (15-minute SLA) and metrics by default.

## Repo Layout

```
terraform/
├── app/                        # Tier 3 — root configuration
│   ├── main.tf                 # Provider, default tags, module calls
│   ├── variables.tf
│   ├── versions.tf
│   └── env/
│       ├── dev/dev.auto.tfvars
│       ├── stg/stg.auto.tfvars
│       └── prd/prd.auto.tfvars
├── simple-bucket/              # Tier 2 — basic bucket + lifecycle
├── cross-account-bucket/       # Tier 2 — cross-account access
├── replication-bucket/         # Tier 2 — versioning + CRR
└── modules/                    # Tier 1 — primitives
    ├── s3_bucket/
    ├── lifecycle_config/
    ├── iam/
    ├── replication/
    ├── access_point/
    └── s3_bucket_encryption/
```

## Prerequisites

- Terraform >= 1.3
- AWS provider >= 5.0
- AWS credentials configured with permissions to manage S3 and IAM

## Deploying an environment

Each environment has its own `auto.tfvars` file under `terraform/app/env/<env>/`.

```bash
cd terraform/app

# Init (first time or after provider/module changes)
terraform init

# Plan against a specific environment
terraform plan -var-file=env/dev/dev.auto.tfvars

# Apply
terraform apply -var-file=env/dev/dev.auto.tfvars
```

When using Terraform Cloud or a CI/CD pipeline, set `TF_CLI_ARGS_plan` and `TF_CLI_ARGS_apply` to point at the correct tfvars file for each workspace.

## Adding a new bucket to an existing pattern

1. Open `env/<env>/<env>.auto.tfvars`.
2. Add a new entry to `simple_buckets`, `cross_account_buckets`, or `replication_buckets`.
3. Run `terraform plan`, then `terraform apply`.

Example — adding a second simple bucket in dev:

```hcl
simple_buckets = {
  "app-data" = { ... }

  "audit-logs" = {
    bucket_name           = "dev-audit-logs-bucket"
    bucket_ownership      = "BucketOwnerEnforced"
    enable_eventbridge    = false
    directories           = []
    create_lifecycle_rule = true
    lifecycle_rule_name   = "expire-logs"
    lifecycle_prefix      = ""
    lifecycle_days        = 365
    vpc_id                = ""
  }
}
```

To restrict bucket access to a VPC, set `vpc_id`. An S3 access point with `vpc_configuration` will be created automatically:

```hcl
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
```

## Adding a new bucket pattern

1. Create a new directory under `terraform/` (e.g. `terraform/event-driven-bucket/`).
2. Add `main.tf`, `data.tf`, `variables.tf`, and `versions.tf` composing the Tier-1 modules you need.
3. Add a corresponding variable block to `terraform/app/variables.tf`.
4. Add a `module` block in `terraform/app/main.tf`.
5. Populate the new variable in each `env/*.auto.tfvars`.

## Default Tags

All resources inherit the following tags via the provider `default_tags` block:

| Tag | Source |
|-----|--------|
| `managed-by` | hardcoded `"terraform"` |
| `environment` | `var.env` |
| `workspace` | `var.workspace` |
| `department` | `var.department` |
| `cost-center` | `var.cost_center` |
| `backup` | `var.backup_type` |

## Environment Conventions

| Environment | Typical region | Notes |
|-------------|----------------|-------|
| `dev` | `us-east-1` | Only `simple_buckets` deployed |
| `stg` | `us-east-1` | All bucket types deployed |
| `prd` | `us-west-2` | All bucket types deployed |

Cross-account and replication buckets are gated to `stg` and `prd` via `count = contains(["stg", "prd"], var.env) ? 1 : 0` in the root. Adjust this as needed for your environment set.

## Security Defaults

Every bucket created through `modules/s3_bucket` has the following applied unconditionally:

- `aws_s3_bucket_public_access_block` — all four public access block settings enabled
- `aws_s3_bucket_ownership_controls` — defaults to `BucketOwnerEnforced` (ACLs disabled)

Optional:

- **KMS encryption** — pass `kms_key_arn` to `modules/s3_bucket`, or use `modules/s3_bucket_encryption` as a standalone resource
- **Versioning** — set `enable_versioning = true` (required for replication)

## Contributing

Pull requests welcome. Run `terraform fmt -recursive` before opening a PR and verify `terraform validate` passes for any modified configuration.
