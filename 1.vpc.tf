# Part 1: Build out VPC and Networking Components
# Step 1a: Create VPC
resource "aws_vpc" "threetierarch_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "3TA_VPC"
  }
}

# Listout AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Step 1b: Create subnets
resource "aws_subnet" "public_subnet_az_1" {
  vpc_id            = aws_vpc.threetierarch_vpc.id
  cidr_block        = var.cidr_pub_sub_1
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "Public-Subnet-AZ1 (3TA)"
  }
}

resource "aws_subnet" "private_subnet_az_1" {
  vpc_id            = aws_vpc.threetierarch_vpc.id
  cidr_block        = var.cidr_pri_sub_1
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "Private-Subnet-AZ1 (3TA)"
  }
}

resource "aws_subnet" "private_db_subnet_az_1" {
  vpc_id            = aws_vpc.threetierarch_vpc.id
  cidr_block        = var.cidr_pri_data_sub_1
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "Private-DB-Subnet-AZ1 (3TA)"
  }
}

resource "aws_subnet" "public_subnet_az_2" {
  vpc_id            = aws_vpc.threetierarch_vpc.id
  cidr_block        = var.cidr_pub_sub_2
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "Public-Subnet-AZ2 (3TA)"
  }
}

resource "aws_subnet" "private_subnet_az_2" {
  vpc_id            = aws_vpc.threetierarch_vpc.id
  cidr_block        = var.cidr_pri_sub_2
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "Private-Subnet-AZ2 (3TA)"
  }
}

resource "aws_subnet" "private_db_subnet_az_2" {
  vpc_id            = aws_vpc.threetierarch_vpc.id
  cidr_block        = var.cidr_pri_data_sub_2
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "Private-DB-Subnet-AZ2 (3TA)"
  }
}

# Step 1c: Create Internet Gateway, Elastic IPs, & NAT Gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.threetierarch_vpc.id
  tags = {
    Name = "3TA-IGW"
  }
}

resource "aws_eip" "eip1" {
  depends_on = [aws_internet_gateway.igw]
  domain     = "vpc"
  tags = {
    Name = "3TA-EIP1"
  }
}
resource "aws_eip" "eip2" {
  depends_on = [aws_internet_gateway.igw]
  domain     = "vpc"
  tags = {
    Name = "3TA-EIP2"
  }
}

resource "aws_nat_gateway" "ngw1" {
  subnet_id     = aws_subnet.public_subnet_az_1.id
  allocation_id = aws_eip.eip1.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "3TA-NAT-GW-AZ1"
  }
}

resource "aws_nat_gateway" "ngw2" {
  subnet_id     = aws_subnet.public_subnet_az_2.id
  allocation_id = aws_eip.eip2.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "3TA-NAT-GW-AZ2"
  }

}

