#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}

#Define the VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "flaskapp-vpc"
    Environment = "Dev"
  }
}

#Deploy the private subnets
resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]
  tags = {
    Name        = "flaskapp-dev-private-subnet-${each.value}"
    Environment = "Dev"
  }
}

#Deploy the Public subnets
resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, each.value + 100)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]
  tags = {
    Name        = "flaskapp-dev-public-subnet-${each.value}"
    Environment = "Dev"
  }
}

#Create route tables for public and private subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name        = "Private Route Table"
    Environment = "Dev"

  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name        = "Public Route Table"
    Environment = "Dev"
  }
}

#Create Route Table Associations
resource "aws_route_table_association" "private" {
  depends_on     = [aws_subnet.private_subnets]
  route_table_id = aws_route_table.private_route_table.id
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.public_subnets]
  route_table_id = aws_route_table.public_route_table.id
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
}

#Create an EIP for NAT Gateway
resource "aws_eip" "nat_gateway_eip" {
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name        = "flaskapp-dev-eip"
    Environment = "Dev"
  }
}

#Create a NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  depends_on    = [aws_subnet.public_subnets]
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id
  tags = {
    Name        = "flaskapp-dev-nat-gatewat"
    Environment = "Dev"
  }
}

#Create an Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "flaskapp-dev-internet-gateway"
    Environment = "Dev"
  }
}

# Create webapp security group
resource "aws_security_group" "webapp_sg" {
  name        = "allow-internet-traffic"
  description = "This security group allows the internet traffic to the webapp application"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow http traffic"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the internet for web traffic
  }
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "flaskapp-dev-webapp-sg"
    Environment = "Dev"
  }
}
