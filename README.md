# Serverlesspizza for Terraform

## DevOps Account

### Create IAM user

Create an IAM user called `devops`, add to new group named `DevOps` which has `AdministratorAccess` permission attached.

Enable programmatic access and update local ~/.aws/config and ~/.aws/credentials files. Use `serverlesspizza-cf-devops` as profile name.

Enable SSH key for Code Commit access. Update the ~/.ssh/config file to include the access key:

```
Host git-codecommit.*.amazonaws.com
  User xxxxxxxxxxxxxxxxxxxx
  IdentityFile ~/.ssh/serverlesspizza-tf-infrastructure
```

### Initialise Terraform resources

In the `devops_account` directory, execute the `init.sh` script. This will create the S3 bucket and DynamoDB table used by Terraform.

Then execute the `apply.sh` script. This will create the AWS resources required to create build pipelines for each deployable artifact.

## Environment (Application) Accounts (dev/prod etc)

### Create IAM user

Create an IAM user called `devops`, add to new group named `DevOps` which has `AdministratorAccess` permission attached.

Enable programmatic access and update local ~/.aws/config and ~/.aws/credentials files. Use `serverlesspizza-cf-dev` and `serverlesspizza-cf-prod` as profile names.

### Initialise Terraform resources

For each of the directories, `dev_account` and `prod_account`:-
- execute the `init.sh` script. This will create the DynamoDB table used by Terraform.
- execute the `apply.sh` script. This will create the AWS resources required.
