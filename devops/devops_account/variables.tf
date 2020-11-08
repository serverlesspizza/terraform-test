variable "default_tags" {
  default = {
    application = "serverlesspizza-tf"
  }
}

variable "aws_region" {
  type = string
}

variable "terraformStateBucketName" {
  type = string
}

variable "artifactBucketName" {
  type = string
}

variable "devAwsAccountId" {
  type = string
}

variable "prodAwsAccountId" {
  type = string
}
