terraform {
  backend "s3" {
    bucket         = "serverlesspizza-tf-state"
    key            = "infrastructure/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "serverlesspizza-tf-locks"
    encrypt        = true
  }
}

