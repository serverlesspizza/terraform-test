module "infrastructure-codepipeline" {
  source = "../../../modules/codepipeline"

  name = "infrastructure-codepipeline"
  artifactBucketName = var.artifactBucketName
  artifactBucketArn = var.artifactBucketArn
  codePipelineRoleArn = var.codePipelineRoleArn
  repositoryName = "serverlesspizza-tf-infrastructure"
  devAwsAccountId = var.devAwsAccountId
  prodAwsAccountId = var.prodAwsAccountId
}
