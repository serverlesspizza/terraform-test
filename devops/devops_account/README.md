# Serverless Pizza DevOps

## Pre-requisites

### AWS profiles
AWS profiles need to be setup and configured locally:-
- serverlesspizza-tf-devops
- serverlesspizza-tf-dev
- serverlesspizza-tf-prod

### Cross account roles
Cross account roles need to be created.

`serverlesspizza-tf-terraform-role` is created in dev and prod accounts. Each allows the devops account to assume that role.

```
"Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "AWS_ACCOUNT_ID"
      },
      "Action": "sts:AssumeRole"
    }
  ]
```

Any resources in devops (or dev/prod) account that allow cross account access should have a policy statement that allows access:

```
"Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "AWS_ACCOUNT_ID"
      },
      "Action": {
        "kms:*"
      },
      "Resources": "*"
    }
  ]
```
