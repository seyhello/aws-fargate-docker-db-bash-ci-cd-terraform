# Get all available zones in the current region
data "aws_availability_zones" "available" {
}

# Create main VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "vpc_${var.cluster_name}"
  }
}

# Create 2 private subnets /25, each in a different AZ
resource "aws_subnet" "private" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.main_vpc.cidr_block, 9, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main_vpc.id

  tags = {
    Name = "sub_priv_${var.cluster_name}_${count.index}"
  }
}

# Create 2 public subnets /25, each in a different AZ
resource "aws_subnet" "public" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.main_vpc.cidr_block, 9, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main_vpc.id
  #  map_public_ip_on_launch = true

  tags = {
    Name = "sub_pub_${var.cluster_name}_${count.index + 2}"
  }
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "igw_${var.cluster_name}"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "igw_eip" {
  count      = 2
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "eip_${var.cluster_name}_${count.index}"
  }
}

resource "aws_nat_gateway" "ngw" {
  count         = 2
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.igw_eip.*.id, count.index)

  tags = {
    Name = "natgw_${var.cluster_name}_${count.index}"
  }
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
  }

  tags = {
    Name = "route_table_priv_${var.cluster_name}_${count.index}"
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
