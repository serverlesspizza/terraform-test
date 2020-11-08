provider "aws" {
  region  = var.aws_region
  profile = "serverlesspizza-tf-devops"
  version = "~> 3.13.0"
}
