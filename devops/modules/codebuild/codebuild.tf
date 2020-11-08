resource "aws_iam_role" "serverlesspizza-tf-codebuild-role" {
  name = "serverlesspizza-tf-codebuild-role"
  tags = var.tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild_policy"
  role = aws_iam_role.serverlesspizza-tf-codebuild-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${var.artifactBucketArn}",
        "${var.artifactBucketArn}/*"
      ]
    },
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${var.terraformStateBucketArn}",
        "${var.terraformStateBucketArn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DeleteLogGroup",
        "logs:DescribeLogGroups",
        "logs:ListTagsLogGroup",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "acm:*",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "iam:*",
        "lambda:*",
        "route53:*",
        "sqs:*",
        "cognito-idp:*",
        "cognito-identity:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "sts:AssumeRole"
      ],
      "Resource": [
        "arn:aws:iam::${var.devAwsAccountId}:role/serverlesspizza-tf-terraform-role",
        "arn:aws:iam::${var.prodAwsAccountId}:role/serverlesspizza-tf-terraform-role"
      ]
    }
  ]
}
EOF
}

resource "aws_codebuild_project" "default" {
  name = "code-build-project"
  description = "Code Build Project"

  service_role = aws_iam_role.serverlesspizza-tf-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_MEDIUM"
    image = "aws/codebuild/standard:4.0"
    type = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name = "BUILD_OUTPUT_BUCKET"
      value = var.artifactBucketName
    }

//    environment_variable {
//      name = "TF_LOG"
//      value = "DEBUG"
//    }

    environment_variable {
      name = "TF_COMMAND"
      value = "destroy"
    }

    environment_variable {
      name = "region"
      value = "eu-west-1"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}
