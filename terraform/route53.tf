data "aws_route53_zone" "this" {
  name = "${var.domain}."
}

resource "aws_route53_record" "website" {
  name    = var.domain
  type    = "A"
  zone_id = data.aws_route53_zone.this.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
  }
}

resource "aws_route53_record" "www" {
  name    = "www.${var.domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.this.zone_id

  alias {
    evaluate_target_health = false
    name                   = module.redirect.website_domain
    zone_id                = module.redirect.hosted_zone_id
  }
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.us-east-1

  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}

resource "aws_route53_record" "sub_api" {
  zone_id = data.aws_route53_zone.this.zone_id
  type    = "NS"
  name    = "api.${var.domain}"
  records = data.aws_route53_zone.this.name_servers
  ttl     = "86400"
}
