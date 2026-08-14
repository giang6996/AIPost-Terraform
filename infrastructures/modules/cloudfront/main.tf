resource "aws_cloudfront_origin_access_control" "frontend" {
  name = "${var.name_prefix}-frontend-oac"

  description = "OAC for AIPost private frontend S3 bucket"

  origin_access_control_origin_type = "s3"

  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "frontend" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  count = var.enable_distribution ? 1 : 0

  aliases = [
    var.frontend_domain_name
  ]

  origin {
    domain_name = var.frontend_bucket_regional_domain_name
    origin_id   = "frontend-s3-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.frontend.id
  }

  default_cache_behavior {
    target_origin_id = "frontend-s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "GET",
      "HEAD"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    compress = true
  }

  viewer_certificate {
    acm_certificate_arn      = var.frontend_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 0
  }

  tags = merge(
    var.common_tags,
    {
      Name    = "${var.name_prefix}-frontend"
      Purpose = "frontend-delivery"
    }
  )
}

data "aws_iam_policy_document" "frontend_bucket" {

  count = var.enable_distribution ? 1 : 0

  statement {
    sid    = "AllowCloudFrontRead"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${var.frontend_bucket_arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        # aws_cloudfront_distribution.frontend.arn
        aws_cloudfront_distribution.frontend[0].arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "frontend_cloudfront" {
  count = var.enable_distribution ? 1 : 0

  bucket = var.frontend_bucket_id
  # policy = data.aws_iam_policy_document.frontend_bucket.json
  policy = data.aws_iam_policy_document.frontend_bucket[0].json
}