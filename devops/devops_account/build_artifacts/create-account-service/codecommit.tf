resource "aws_codecommit_repository" "create-account-service" {
  repository_name = "serverlesspizza-tf-create-account-service"
  description     = "Serverless Pizza Terraform - Create Account Service"
}
