resource "aws_codecommit_repository" "static-content" {
  repository_name = "serverlesspizza-tf-static-content"
  description     = "Serverless Pizza Terraform - Static Content"
}
