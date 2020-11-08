variable "terraformStateBucketArn" {
  type = string
}

variable "artifactBucketName" {
  type = string
}

variable "artifactBucketArn" {
  type = string
}

variable "devAwsAccountId" {
  type = string
}

variable "prodAwsAccountId" {
  type = string
}

variable "tags" {
  type = map
}
