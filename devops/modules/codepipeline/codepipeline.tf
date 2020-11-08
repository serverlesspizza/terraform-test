resource "aws_codepipeline" "default" {
  name = var.name
  role_arn = var.codePipelineRoleArn

  artifact_store {
    location = var.artifactBucketName
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "CodeCommit"
      version = "1"
      output_artifacts = [
        "source_output"]

      configuration = {
        RepositoryName = var.repositoryName
        BranchName = "master"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Deploy-dev"

    action {
      name = "Deploy-dev"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["source_output"]
      output_artifacts = ["dev_build_output"]
      version = "1"

      configuration = {
        ProjectName = "code-build-project"
        EnvironmentVariables = <<-EOT
        [
          {
            "name":"TF_VAR_ENVIRONMENT",
            "type":"PLAINTEXT",
            "value":"dev"
          },
          {
            "name":"assume_role_arn",
            "type":"PLAINTEXT",
            "value":"arn:aws:iam::${var.devAwsAccountId}:role/serverlesspizza-tf-terraform-role"
          }
        ]
        EOT
      }
    }
  }

  stage {
    name = "Deploy-prod"

    action {
      name = "Deploy-prod"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["source_output"]
      output_artifacts = ["prod_build_output"]
      version = "1"

      configuration = {
        ProjectName = "code-build-project"
        EnvironmentVariables = <<-EOT
        [
          {
            "name":"TF_VAR_ENVIRONMENT",
            "type":"PLAINTEXT",
            "value":"prod"
          },
          {
            "name":"assume_role_arn",
            "type":"PLAINTEXT",
            "value":"arn:aws:iam::${var.prodAwsAccountId}:role/serverlesspizza-tf-terraform-role"
          }
        ]
        EOT
      }
    }
  }
}
