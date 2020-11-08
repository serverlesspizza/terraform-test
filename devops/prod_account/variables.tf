variable "default_tags" {
  default = {
    application = "serverlesspizza-tf"
  }
}

variable "aws_region" {
  type = string
}

variable "devops_aws_account_id" {
  type = string
}
