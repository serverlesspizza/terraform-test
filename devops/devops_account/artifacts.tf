locals {
  codepipeline_role_name = "serverlesspizza-tf-codepipeline-role"
}

data "aws_s3_bucket" "serverlesspizza-tf-state" {
  bucket = "serverlesspizza-tf-state"
}

module "artifact-bucket" {
  source = "../modules/s3-bucket"
  name   = var.artifactBucketName
  tags   = var.default_tags
}

module "code-pipeline-iam-role" {
  source = "../modules/iam_role"

  name   = local.codepipeline_role_name
  tags   = var.default_tags
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

module "code-pipeline-iam-policy" {
  source = "../modules/iam_policy"

  name   = "serverlesspizza-tf-codepipeline-policy"
  role   = local.codepipeline_role_name
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
        "${module.artifact-bucket.s3BucketArn}",
        "${module.artifact-bucket.s3BucketArn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:UploadArchive",
        "codecommit:GetUploadArchiveStatus"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

module "codebuild" {
  source = "../modules/codebuild"

  terraformStateBucketArn = data.aws_s3_bucket.serverlesspizza-tf-state.arn
  devAwsAccountId         = var.devAwsAccountId
  prodAwsAccountId        = var.prodAwsAccountId
  artifactBucketName      = module.artifact-bucket.s3BucketName
  artifactBucketArn       = module.artifact-bucket.s3BucketArn
  tags                    = var.default_tags
}

module "account-service" {
  source = "./buildartifact"

  artifactName = "serverlesspizza-tf-account-service"
  artifactDescription = "Serverless Pizza Terraform - Account Service"
  artifactBucketName  = module.artifact-bucket.s3BucketName
  artifactBucketArn   = module.artifact-bucket.s3BucketArn
  codePipelineRoleArn = module.code-pipeline-iam-role.codePipelineRoleArn
  devAwsAccountId     = var.devAwsAccountId
  prodAwsAccountId    = var.prodAwsAccountId
}

module "create-account-service" {
  source = "./build_artifacts/create-account-service"

  artifactBucketName  = module.artifact-bucket.s3BucketName
  artifactBucketArn   = module.artifact-bucket.s3BucketArn
  codePipelineRoleArn = module.code-pipeline-iam-role.codePipelineRoleArn
  devAwsAccountId     = var.devAwsAccountId
  prodAwsAccountId    = var.prodAwsAccountId
}

module "infrastructure" {
  source = "./build_artifacts/infrastructure"

  artifactBucketName  = module.artifact-bucket.s3BucketName
  artifactBucketArn   = module.artifact-bucket.s3BucketArn
  codePipelineRoleArn = module.code-pipeline-iam-role.codePipelineRoleArn
  devAwsAccountId     = var.devAwsAccountId
  prodAwsAccountId    = var.prodAwsAccountId
}

module "order-service" {
  source = "./build_artifacts/order-service"
}

module "product-service" {
  source = "./build_artifacts/product-service"
}

module "static-content" {
  source = "./build_artifacts/static-content"
}

module "website" {
  source = "./build_artifacts/website"
}
