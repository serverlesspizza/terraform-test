module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 1.0"

  zones = {
    (var.api_domain_name) = {
      comment = var.api_domain_name
      tags = merge(
        var.default_tags,
        {
          "environment" = var.ENVIRONMENT
        }
      )
    }
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 1.0"

  zone_name = keys(module.zones.this_route53_zone_zone_id)[0]

  records = [
    {
      name = ""
      type = "A"
      ttl  = 3600
      records = [
        "10.10.10.11",
      ]
    },
  ]
}
