provider "aws" {
  region  = var.aws_region
  profile = "serverlesspizza-tf-dev"
  version = "~> 3.13.0"
}
