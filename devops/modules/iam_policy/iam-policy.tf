resource "aws_iam_role_policy" "codepipeline_policy" {
  name = var.name
  role = var.role
  policy = var.policy
}
