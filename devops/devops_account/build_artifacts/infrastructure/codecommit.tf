resource "aws_codecommit_repository" "infrastructure" {
  repository_name = "serverlesspizza-tf-infrastructure"
  description = "Serverless Pizza Terraform - Infrastructure"
}
