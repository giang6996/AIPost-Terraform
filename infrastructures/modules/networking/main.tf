# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-vpc"
    }
  )
}

# Public Subnet, each in one availbility zone
resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.this.id
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-public-${count.index + 1}"
      Tier = "public"
      AZ   = var.availability_zones[count.index]
    }
  )
}

# Private Subnet for Backend Instance, each in one availbility zone
resource "aws_subnet" "private_app" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.this.id
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = var.private_app_subnet_cidrs[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-app-${count.index + 1}"
      Tier = "private-application"
      AZ   = var.availability_zones[count.index]
    }
  )
}

# Private Subnet for PostgreSQL RDS Instance, each in one availbility zone
resource "aws_subnet" "private_db" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.this.id
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = var.private_db_subnet_cidrs[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-db-${count.index + 1}"
      Tier = "private-database"
      AZ   = var.availability_zones[count.index]
    }
  )
}

# Internet Gateway for accessing public internet
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-igw"
    }
  )
}

# Create a new custom route table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-public-rt"
      Tier = "public"
    }
  )
}

# Default route for new route table
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Create association route to both public subnet
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Allocate one Elastic IP for NAT Gateway
# For prod, need at least 2 EIP for 2 NAT Gateway
resource "aws_eip" "nat" {
  count = var.nat_mode == "per_az" ? length(var.availability_zones) : 1

  domain = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-nat-eip-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

# Create NAT Gateway
# For Demo, 1 NAT Gateway is sufficient
# For Prod, remember to create 2 NAT Gateway for each Public Subnet
resource "aws_nat_gateway" "this" {
  count = var.nat_mode == "per_az" ? length(var.availability_zones) : 1

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-nat-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}


# Create new custom route table for private backend instance
# 2 rtb to accomodate 2 NATG in prod
resource "aws_route_table" "private_app" {
  count = length(aws_subnet.private_app)

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-app-${count.index + 1}-rt"
      Tier = "private-application"
    }
  )
}

# Route each private route table to the public NATG as outbound conn
resource "aws_route" "private_app_nat" {
  count = length(aws_route_table.private_app)

  route_table_id         = aws_route_table.private_app[count.index].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = (
    var.nat_mode == "per_az"
    ? aws_nat_gateway.this[count.index].id
  : aws_nat_gateway.this[0].id)
}

resource "aws_route_table_association" "private_app" {
  count = length(aws_subnet.private_app)

  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private_app[count.index].id
}



resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-db-rt"
      Tier = "private-database"
    }
  )
}

resource "aws_route_table_association" "private_db" {
  count = length(aws_subnet.private_db)

  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_db.id
}


