output "role_arn" {
  description = "ARN of the IAM role, if created. Returns null when create_iam_role is false."
  value       = var.create_iam_role ? aws_iam_role.this[0].arn : null
}

output "policy_arn" {
  description = "ARN of the IAM policy, if created. Returns null when create_iam_role is false."
  value       = var.create_iam_role ? aws_iam_policy.this[0].arn : null
}
