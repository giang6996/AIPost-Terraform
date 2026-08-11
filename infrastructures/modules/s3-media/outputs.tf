output "bucket_id" {
  description = "Name of the frontend S3 bucket."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the frontend S3 bucket."
  value       = aws_s3_bucket.this.arn
}

output "regional_domain_name" {
  description = "Regional domain name used later by CloudFront."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}