resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  tags = merge(
    var.default_tags,
    {
      "environment" = var.ENVIRONMENT
    }
  )
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "cognito-pre-sign-up"
  description   = "Cognito pre-sign up lambda"
  handler       = "index.lambda_handler"
  runtime       = "nodejs12.x"

  source_path = "./pre-signup-lambda"
  environment_variables = {
    ENVIRONMENT : var.ENVIRONMENT
    REGION : var.aws_region
    ACCOUNT_ID : var.aws_account_id
  }
  tags = merge(
    var.default_tags,
    {
      "environment" = var.ENVIRONMENT
    }
  )
}

resource "aws_sqs_queue" "terraform_queue" {
  name                      = "serverlesspizza-dev-pre-signup-lambda"
  delay_seconds             = 5
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  tags = merge(
    var.default_tags,
    {
      "environment" = var.ENVIRONMENT
    }
  )
}

resource "aws_cognito_user_pool" "pool" {
  name = "cf-serverlesspizza-dev-user-pool"
  username_attributes = [
  "email"]
  lambda_config {
    pre_sign_up = module.lambda_function.this_lambda_function_arn
  }
  tags = merge(
    var.default_tags,
    {
      "environment" = var.ENVIRONMENT
    }
  )
}

resource "aws_cognito_user_pool_client" "client" {
  name            = "cf-serverlesspizza-dev-client"
  user_pool_id    = aws_cognito_user_pool.pool.id
  generate_secret = false
}

resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = "cf_serverlesspizza_dev_identity_pool"
  allow_unauthenticated_identities = true

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.client.id
    provider_name           = aws_cognito_user_pool.pool.endpoint
    server_side_token_check = false
  }
}

resource "aws_iam_role" "authenticated" {
  name = "cognito_authenticated"
  tags = merge(
    var.default_tags,
    {
      "environment" = var.ENVIRONMENT
    }
  )
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.main.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "authenticated" {
  name = "authenticated_policy"
  role = aws_iam_role.authenticated.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents",
        "cognito-sync:*",
        "cognito-identity:*",
        "execute-api:Invoke",
        "execute-api:ManageConnections"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "unauthenticated" {
  name = "cognito_unauthenticated"
  tags = merge(
    var.default_tags,
    {
      "environment" = var.ENVIRONMENT
    }
  )
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.main.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "unauthenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "unauthenticated" {
  name = "unauthenticated_policy"
  role = aws_iam_role.unauthenticated.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents",
        "cognito-sync:*",
        "execute-api:Invoke",
        "execute-api:ManageConnections"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = aws_cognito_identity_pool.main.id

  role_mapping {
    identity_provider         = "cognito-idp.eu-west-1.amazonaws.com/${aws_cognito_user_pool.pool.id}:${aws_cognito_user_pool_client.client.id}"
    type                      = "Token"
    ambiguous_role_resolution = "AuthenticatedRole"
  }

  roles = {
    "authenticated"   = aws_iam_role.authenticated.arn
    "unauthenticated" = aws_iam_role.unauthenticated.arn
  }
}
