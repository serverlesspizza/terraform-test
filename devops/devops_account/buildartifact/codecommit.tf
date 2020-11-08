resource "aws_codecommit_repository" "create-account-service" {
  repository_name = var.artifactName
  description     = var.artifactDescription
}
