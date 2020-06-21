# Get all available zones in the current region
data "aws_availability_zones" "available" {
}

# Create main VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "vpc_${var.vpc_name}"
  }
}

# Create 2 public subnets /25, each in a different AZ
resource "aws_subnet" "public" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.main_vpc.cidr_block, 9, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main_vpc.id
  #  map_public_ip_on_launch = true

  tags = {
    Name = "sub_pub_${var.vpc_name}_${count.index}"
  }
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "igw_${var.vpc_name}"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
