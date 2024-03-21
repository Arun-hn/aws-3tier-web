# Step 1e: Create 5 Security Groups
resource "aws_security_group" "internetlb-sg" {
  name        = "Internet-Facing-LB-SG"
  description = "External load balancer security group"
  vpc_id      = aws_vpc.threetierarch_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${local.my_ip_address}/32", "0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${local.my_ip_address}/32", "0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "3TA-Internet-Facing-LB-SG"
  }
}

resource "aws_security_group" "webtier-sg" {
  name        = "WebTier-SG"
  description = "SG for the Web Tier"
  vpc_id      = aws_vpc.threetierarch_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["${local.my_ip_address}/32"]
    security_groups = [aws_security_group.internetlb-sg.id]
  }
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["${local.my_ip_address}/32"]
    security_groups = [aws_security_group.internetlb-sg.id]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["${local.my_ip_address}/32"]
    security_groups = [aws_security_group.internetlb-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "3TA-WebTier-SG"
  }
}

resource "aws_security_group" "internallb-sg" {
  name        = "Internal-LB-SG"
  description = "SG for the internal load balancer"
  vpc_id      = aws_vpc.threetierarch_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.webtier-sg.id]
  }
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.webtier-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "3TA-Internal-LB-SG"
  }
}

resource "aws_security_group" "private-instance-sg" {
  name        = "PrivateInstanceSG"
  description = "SG for our private app tier sg"
  vpc_id      = aws_vpc.threetierarch_vpc.id

  ingress {
    from_port       = 4000
    to_port         = 4000
    protocol        = "tcp"
    cidr_blocks     = ["${local.my_ip_address}/32"]
    security_groups = [aws_security_group.internallb-sg.id]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["${local.my_ip_address}/32"]
    security_groups = [aws_security_group.internallb-sg.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "3TA-PrivateInstanceSG"
  }
}

resource "aws_security_group" "db-sg" {
  name        = "DBSG"
  description = "SG for our databases"
  vpc_id      = aws_vpc.threetierarch_vpc.id

  ingress {
    from_port       = 3006
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.private-instance-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "3TA-DBSG"
  }
}


