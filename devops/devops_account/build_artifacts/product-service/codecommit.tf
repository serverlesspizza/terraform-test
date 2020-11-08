resource "aws_codecommit_repository" "product-service" {
  repository_name = "serverlesspizza-tf-product-service"
  description     = "Serverless Pizza Terraform - Product Service"
}
