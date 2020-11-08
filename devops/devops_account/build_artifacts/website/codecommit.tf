resource "aws_codecommit_repository" "website" {
  repository_name = "serverlesspizza-tf-website"
  description     = "Serverless Pizza Terraform - Website"
}
