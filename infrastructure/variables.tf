variable "default_tags" {
  default = {
    application = "serverlesspizza-tf"
  }
}

variable "ENVIRONMENT" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "api_domain_name" {
  type = string
}
