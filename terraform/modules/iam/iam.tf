resource "aws_iam_role" "this" {
  count              = var.create_iam_role ? 1 : 0
  name               = "${var.bucket_name}-role"
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "this" {
  count  = var.create_iam_role ? 1 : 0
  name   = "${var.bucket_name}-policy"
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.create_iam_role ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}
