resource "aws_codecommit_repository" "order-service" {
  repository_name = "serverlesspizza-tf-order-service"
  description     = "Serverless Pizza Terraform - Order Service"
}
