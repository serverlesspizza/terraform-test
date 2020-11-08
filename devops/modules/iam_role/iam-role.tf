resource "aws_iam_role" "codepipeline-role" {
  name = var.name
  assume_role_policy = var.policy
  tags = var.tags
}
