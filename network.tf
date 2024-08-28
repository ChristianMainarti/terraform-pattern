resource "aws_vpc" "prod-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name        = "prod-vpc"
    Application = "app name"
    Environment = ""
  }
}

resource "aws_subnet" "subnet1_pvt" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.10.2.0/24"
  map_public_ip_on_launch = false
  tags = {
    name = "prod-pvt-appname-subnet-us-east-2a"
  }
}

resource "aws_subnet" "subnet2_pvt" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.10.3.0/24"
  map_public_ip_on_launch = false
  tags = {
    name = "prod-pvt-appname-subnet-us-east-2b"
  }
}

resource "aws_subnet" "subnet1_pub" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.10.4.0/24"
  map_public_ip_on_launch = true
  tags = {
    name = "prod-pub-appname-subnet-us-east-2a"
  }
}

resource "aws_subnet" "subnet2_pub" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.10.5.0/24"
  map_public_ip_on_launch = true
  tags = {
    name = "prod-pub-appname-subnet-us-east-2b"
  }
}

resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id
  tags = {
    Name = "prod-pvt-igw-us-east-2a"
  }
}

resource "aws_eip" "prod-eip-us-east-2a" {
  tags = {
    Name = "prod-eip-us-east-2a"
  }
}

resource "aws_nat_gateway" "prod-pvt-ngw" {
  allocation_id = aws_eip.prod-eip-us-east-2a.id
  subnet_id     = aws_subnet.subnet1_pub.id

  tags = {
    Name = "prod-pvt-ngw-us-east-2a"
  }

  depends_on = [aws_internet_gateway.prod-igw]
}

resource "aws_route_table" "rtb_a" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.prod-pvt-ngw.id
  }
  route {
    cidr_block = "10.10.2.0/24"
    gateway_id = "local"
  }
  tags = {
    Name        = "prod-appname-rtb-us-east-2a-pvt"
    Application = "app name"
    Environment = "production"
  }
}

resource "aws_route_table" "rtb_b" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.prod-pvt-ngw.id
  }
  route {
    cidr_block = "10.10.3.0/24"
    gateway_id = "local"
  }
  tags = {
    Name        = "prod-appname-rtb-us-east-2b-pvt"
    Application = "app name"
    Environment = "production"
  }
}

resource "aws_route_table" "rtb-pub-a" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-igw.id
  }
  route {
    cidr_block = "10.10.4.0/24"
    gateway_id = "local"
  }
  tags = {
    Name        = "prod-appname-rtb-us-east-2b-pvt"
    Application = "app name"
    Environment = "production"
  }
}

resource "aws_route_table_association" "rtb-pvt-us-east-2a-association" {
  subnet_id      = aws_subnet.subnet1_pvt.id
  route_table_id = aws_route_table.rtb_a.id
}

resource "aws_route_table_association" "rtb-pvt-us-east-2b-association" {
  subnet_id      = aws_subnet.subnet2_pvt.id
  route_table_id = aws_route_table.rtb_b.id
}

resource "aws_route_table_association" "rtb-pub-us-east-2a-association1" {
  subnet_id      = aws_subnet.subnet1_pub.id
  route_table_id = aws_route_table.rtb-pub-a.id
}

resource "aws_route_table_association" "rtb-pub-us-east-2a-association2" {
  subnet_id      = aws_subnet.subnet2_pub.id
  route_table_id = aws_route_table.rtb-pub-a.id
}

resource "aws_security_group" "SG-for-RDS" {
  description = ""
  vpc_id      = aws_vpc.prod-vpc.id
  tags = {
    name        = "prod-pvt-igw-us-east-2"
    Application = "app name"
    Environment = "environment"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_pg" {
  security_group_id = aws_security_group.SG-for-RDS.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
  description       = "allow traffic from ECS to RDS"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_1" {
  security_group_id = aws_security_group.SG-for-RDS.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "allow traffic ipv4 from ECS to RDS"
}

resource "aws_security_group" "SG-for-ECS" {
  description = ""
  vpc_id      = aws_vpc.prod-vpc.id
  tags = {
    name        = "prod-appname-sg-us-east-2-ecs"
    Application = "app name"
    Environment = "environment"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.SG-for-ECS.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "-1"
  to_port           = "-1"
  ip_protocol       = "-1"
  description       = "allow all traffic to ECS"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https1" {
  security_group_id = aws_security_group.SG-for-ECS.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "allow https traffic to ECS"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_2" {
  security_group_id = aws_security_group.SG-for-ECS.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "allow all traffic from ECS"
}

resource "aws_security_group" "SG-for-ALB" {
  description = ""
  vpc_id      = aws_vpc.prod-vpc.id
  tags = {
    name        = "prod-appname-sg-us-east-2-alb"
    Application = "app name"
    Environment = "environment"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https2" {
  security_group_id = aws_security_group.SG-for-ALB.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "allow https traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.SG-for-ALB.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "allow http traffic"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.SG-for-ALB.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
