module "create-account-service-codepipeline" {
  source = "../../modules/codepipeline"

  name = var.artifactName
  artifactBucketName = var.artifactBucketName
  artifactBucketArn = var.artifactBucketArn
  codePipelineRoleArn = var.codePipelineRoleArn
  repositoryName = var.artifactName
  devAwsAccountId = var.devAwsAccountId
  prodAwsAccountId = var.prodAwsAccountId
}
