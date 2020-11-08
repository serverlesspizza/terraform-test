provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = "terraform.dev"
  version = "~> 3.3.0"
}

data "aws_route53_zone" "this" {
  name         = var.api_domain_name
  private_zone = false
  depends_on   = [module.zones]
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> v2.0"

  domain_name = var.api_domain_name
  zone_id     = data.aws_route53_zone.this.zone_id

  validation_method = "EMAIL"

  tags = merge(
    var.default_tags,
    {
      "environment" = var.ENVIRONMENT
    }
  )

  providers = {
    aws = aws.us-east-1
  }

  depends_on = [module.records]
}
