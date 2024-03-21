# Step 1d: Create route tables and subnet associations
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.threetierarch_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "3TA-PublicRouteTable"
  }
}

resource "aws_route_table_association" "pubsubnetassociations1" {
  subnet_id      = aws_subnet.public_subnet_az_1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "pubsubnetassociations2" {
  subnet_id      = aws_subnet.public_subnet_az_2.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table" "private_app_route_az1" {
  vpc_id = aws_vpc.threetierarch_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw1.id
  }

  tags = {
    Name = "3TA-Private-Route-Table-AZ1"
  }
}

resource "aws_route_table_association" "prisubnetassociations1" {
  subnet_id      = aws_subnet.private_subnet_az_1.id
  route_table_id = aws_route_table.private_app_route_az1.id
}

resource "aws_route_table" "private_app_route_az2" {
  vpc_id = aws_vpc.threetierarch_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw2.id
  }

  tags = {
    Name = "3TA-Private-Route-Table-AZ2"
  }
}

resource "aws_route_table_association" "prisubnetassociations2" {
  subnet_id      = aws_subnet.private_subnet_az_2.id
  route_table_id = aws_route_table.private_app_route_az2.id
}
