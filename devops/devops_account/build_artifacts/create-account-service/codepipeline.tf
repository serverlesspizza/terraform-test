module "create-account-service-codepipeline" {
  source = "../../../modules/codepipeline"

  name = "create-account-service-codepipeline"
  artifactBucketName = var.artifactBucketName
  artifactBucketArn = var.artifactBucketArn
  codePipelineRoleArn = var.codePipelineRoleArn
  repositoryName = "serverlesspizza-tf-create-account-service"
  devAwsAccountId = var.devAwsAccountId
  prodAwsAccountId = var.prodAwsAccountId
}
