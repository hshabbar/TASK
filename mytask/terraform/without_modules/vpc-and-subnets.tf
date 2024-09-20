resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "VPC for task"
  }
}


resource "aws_subnet" "my_public_subnet_one" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_one_cidr
  availability_zone = var.public_subnet_one_availability_zone
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Public subnet one for the task"
  }
}


resource "aws_subnet" "my_public_subnet_two" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_two_cidr
  availability_zone = var.public_subnet_two_availability_zone
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Public subnet two for the task"
  }
}


resource "aws_subnet" "my_private_subnet_one" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_one_cidr
  availability_zone = var.private_subnet_one_availability_zone
  tags = {
    Name = "Private subnet one for the task"
  }
}


resource "aws_subnet" "my_private_subnet_two" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_two_cidr
  availability_zone = var.private_subnet_two_availability_zone
  tags = {
    Name = "Private subnet two for the task"
  }
}


resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Internet Gateway for public subnets's route table"
  }
}


resource "aws_eip" "my_elastic_ip_for_nat_one" {
}


resource "aws_eip" "my_elastic_ip_for_nat_two" {
}


resource "aws_nat_gateway" "my_nat_gateway_one" {
  allocation_id = aws_eip.my_elastic_ip_for_nat_one.id
  subnet_id     = aws_subnet.my_public_subnet_one.id
  tags = {
    Name = "Nat gateway for private subnet's route table one"
  }
  depends_on = [aws_internet_gateway.my_internet_gateway]
}


resource "aws_nat_gateway" "my_nat_gateway_two" {
  allocation_id = aws_eip.my_elastic_ip_for_nat_two.id
  subnet_id     = aws_subnet.my_public_subnet_two.id
  tags = { 
    Name = "Nat gateway for private subnet's route table two"
  }
  depends_on = [aws_internet_gateway.my_internet_gateway]
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }
  tags = {
    Name = "Route table for public subnet"
  }
}


resource "aws_route_table" "private_route_table_one" {
  vpc_id = aws_vpc.my_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gateway_one.id
  }
  tags = {
    Name = "Route table for private subnet one"
  }
}


resource "aws_route_table" "private_route_table_two" {
  vpc_id = aws_vpc.my_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my_nat_gateway_two.id
  }
  tags = {
    Name = "Route table for private subnet two"
  }
}


resource "aws_route_table_association" "public_route_table_association_one" {
  subnet_id      = aws_subnet.my_public_subnet_one.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "public_route_table_association_two" {
  subnet_id      = aws_subnet.my_public_subnet_two.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "private_route_table_association_one" {
  subnet_id      = aws_subnet.my_private_subnet_one.id
  route_table_id = aws_route_table.private_route_table_one.id
}


resource "aws_route_table_association" "private_route_table_association_two" {
  subnet_id      = aws_subnet.my_private_subnet_two.id
  route_table_id = aws_route_table.private_route_table_two.id
}
