output "frontend_oac_id" {
  description = "CloudFront Origin Access Control ID for the frontend S3 origin."
  value       = aws_cloudfront_origin_access_control.frontend.id
}

# output "distribution_id" {
#   description = "CloudFront frontend distribution ID."
#   value       = aws_cloudfront_distribution.frontend.id
# }

# output "distribution_arn" {
#   description = "CloudFront frontend distribution ARN."
#   value       = aws_cloudfront_distribution.frontend.arn
# }

# output "distribution_domain_name" {
#   description = "CloudFront-generated domain name."
#   value       = aws_cloudfront_distribution.frontend.domain_name
# }

# output "distribution_hosted_zone_id" {
#   description = "Hosted zone ID used by Route 53 aliases to CloudFront."
#   value       = aws_cloudfront_distribution.frontend.hosted_zone_id
# }

output "distribution_id" {
  value = try(
    aws_cloudfront_distribution.frontend[0].id,
    null
  )
}

output "distribution_arn" {
  value = try(
    aws_cloudfront_distribution.frontend[0].arn,
    null
  )
}

output "distribution_domain_name" {
  value = try(
    aws_cloudfront_distribution.frontend[0].domain_name,
    null
  )
}

output "distribution_hosted_zone_id" {
  value = try(
    aws_cloudfront_distribution.frontend[0].hosted_zone_id,
    null
  )
}