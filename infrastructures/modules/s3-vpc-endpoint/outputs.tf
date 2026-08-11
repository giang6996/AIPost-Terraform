output "endpoint_id" {
  description = "ID of the S3 Gateway VPC Endpoint."
  value       = aws_vpc_endpoint.s3.id
}

output "prefix_list_id" {
  description = "AWS-managed S3 prefix list used by the endpoint route."
  value       = aws_vpc_endpoint.s3.prefix_list_id
}