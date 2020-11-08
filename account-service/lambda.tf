module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name          = "account-service"
  description            = "Account Service Lambda"
  handler                = "com.serverlesspizza.service.account.StreamLambdaHandler::handleRequest"
  runtime                = "java8"
  create_package         = false
  local_existing_package = "./target/account-service-1.0-SNAPSHOT-lambda-package.zip"
  memory_size            = 512
  timeout                = 30
  environment_variables = {
    ENVIRONMENT : var.ENVIRONMENT
    REGION : var.aws_region
    ACCOUNT_ID : var.aws_account_id
  }
  allowed_triggers = {
    APIGatewayAny = {
      service = "apigateway"
      arn = aws_api_gateway_rest_api.AccountServiceAPI.arn
    }
  }

  tags = merge(
    var.default_tags,
    {
      "environment" = var.ENVIRONMENT
    }
  )
}

resource "aws_api_gateway_rest_api" "AccountServiceAPI" {
  name        = "AccountServiceAPI"

}
