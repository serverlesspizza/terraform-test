resource "aws_codecommit_repository" "account-service" {
  repository_name = "serverlesspizza-tf-account-service"
  description     = "Serverless Pizza Terraform - Account Service"
}
