output "vpc_id" {
  description = "ID of the AIPost VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block assigned to the AIPost VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets, ordered by Availability Zone."
  value       = aws_subnet.public[*].id
}

output "private_app_subnet_ids" {
  description = "IDs of private application subnets, ordered by Availability Zone."
  value       = aws_subnet.private_app[*].id
}

output "private_db_subnet_ids" {
  description = "IDs of private database subnets, ordered by Availability Zone."
  value       = aws_subnet.private_db[*].id
}

output "availability_zones" {
  description = "Availability Zones used by the networking module."
  value       = var.availability_zones
}

output "public_subnet_cidrs" {
  description = "CIDR blocks assigned to public subnets."
  value       = aws_subnet.public[*].cidr_block
}

output "private_app_subnet_cidrs" {
  description = "CIDR blocks assigned to private application subnets."
  value       = aws_subnet.private_app[*].cidr_block
}

output "private_db_subnet_cidrs" {
  description = "CIDR blocks assigned to private database subnets."
  value       = aws_subnet.private_db[*].cidr_block
}

output "internet_gateway_id" {
  description = "ID of the VPC Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_app_route_table_ids" {
  description = "IDs of private application route tables."
  value       = aws_route_table.private_app[*].id
}

output "private_db_route_table_id" {
  description = "ID of the private database route table."
  value       = aws_route_table.private_db.id
}

output "nat_gateway_ids" {
  description = "IDs of NAT Gateways created by the networking module."
  value       = aws_nat_gateway.this[*].id
}

output "nat_public_ips" {
  description = "Public Elastic IP addresses assigned to NAT Gateways."
  value       = aws_eip.nat[*].public_ip
}

output "nat_mode" {
  description = "Selected NAT Gateway topology."
  value       = var.nat_mode
}