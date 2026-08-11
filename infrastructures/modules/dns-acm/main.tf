resource "aws_acm_certificate" "frontend" {
  provider = aws.us_east_1

  domain_name       = var.frontend_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.common_tags,
    {
      Name    = "${var.frontend_domain_name}-certificate"
      Purpose = "cloudfront"
    }
  )
}

resource "aws_acm_certificate" "api" {
  domain_name       = var.api_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.common_tags,
    {
      Name    = "${var.api_domain_name}-certificate"
      Purpose = "alb"
    }
  )
}

resource "aws_route53_record" "frontend_validation" {
  for_each = {
    for dvo in aws_acm_certificate.frontend.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.hosted_zone_id

  name = each.value.name
  type = each.value.type
  ttl  = 60

  records = [
    each.value.record
  ]
}

resource "aws_route53_record" "api_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.hosted_zone_id

  name = each.value.name
  type = each.value.type
  ttl  = 60

  records = [
    each.value.record
  ]
}

resource "aws_acm_certificate_validation" "frontend" {
  provider = aws.us_east_1

  certificate_arn = aws_acm_certificate.frontend.arn

  validation_record_fqdns = [
    for record in aws_route53_record.frontend_validation :
    record.fqdn
  ]
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn = aws_acm_certificate.api.arn

  validation_record_fqdns = [
    for record in aws_route53_record.api_validation :
    record.fqdn
  ]
}
