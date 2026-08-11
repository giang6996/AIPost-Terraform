resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.route_table_ids

  tags = merge(
    var.common_tags,
    {
      Name    = "${var.name_prefix}-s3-gateway-endpoint"
      Service = "s3"
    }
  )
}