locals {
  terraform_role_name = "serverlesspizza-tf-terraform-role"
}

module "terraform-role" {
  source = "../modules/iam_role"

  name   = local.terraform_role_name
  tags   = var.default_tags
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.devops_aws_account_id}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

module "terraform_policy" {
  source = "../modules/iam_policy"

  name   = "terraform_policy"
  role   = local.terraform_role_name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObject"
      ],
      "Resource": [
          "arn:aws:s3:::serverlesspizza-tf-state",
          "arn:aws:s3:::serverlesspizza-tf-state/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "acm:*",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "iam:*",
        "logs:*",
        "lambda:*",
        "route53:*",
        "s3:*",
        "kms:*",
        "sqs:*",
        "cognito-idp:*",
        "cognito-identity:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
