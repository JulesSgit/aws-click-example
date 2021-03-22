# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "main"
  }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet gateway"
  }
}

# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.private.id

  tags = {
    Name = "NAT"
  }
}

# ROUTE TABLE
resource "aws_route_table" "route_table_public_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "route table public a"
  }
}

resource "aws_route_table" "route_table_public_c" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "route table public c"
  }
}

resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private route table"
  }
}

resource "aws_route_table_association" "route_table_public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.route_table_public_a.id
}

resource "aws_route_table_association" "route_table_public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.route_table_public_c.id
}

resource "aws_route_table_association" "route_table_private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.route_table_private.id
}

# SUBNET
resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public subnet"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "public subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private subnet"
  }
}
