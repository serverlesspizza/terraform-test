provider "aws" {
  region  = var.aws_region
  profile = "serverlesspizza-tf-prod"
  version = "~> 3.13.0"
}
