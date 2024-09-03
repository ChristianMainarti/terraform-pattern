resource "aws_network_interface" "eni_pvt_subnet_1" {
  subnet_id       = aws_subnet.subnet1_pvt
  private_ips     = ["10.0.2.11"]
  security_groups = [aws_security_group.SG-for-ALB.id]

  tags = {
    Name        = "staging-eni-pvt-subnet1-alb"
    Application = "appname"
    Environment = "staging"
  }
}

resource "aws_network_interface" "eni_pvt_subnet_2" {
  subnet_id       = aws_subnet.subnet1_pvt
  private_ips     = ["10.0.2.24"]
  security_groups = [aws_security_group.SG-for-ECS.id]

  tags = {
    Name        = "staging-eni-pvt-subnet1-ecs"
    Application = "appname"
    Environment = "staging"
  }
}

resource "aws_network_interface" "eni_pvt_subnet_3" {
  subnet_id       = aws_subnet.subnet1_pvt
  private_ips     = ["10.0.2.67"]
  security_groups = [aws_security_group.SG-for-vpc_link.id]

  tags = {
    Name        = "staging-eni-pvt-subnet1-vpclink"
    Application = "appname"
    Environment = "staging"
  }
}

resource "aws_network_interface" "eni_pvt_subnet2_1" {
  subnet_id       = aws_subnet.subnet2_pvt
  private_ips     = ["10.0.3.32"]
  security_groups = [aws_security_group.SG-for-ALB.id]

  tags = {
    Name        = "staging-eni-pvt-subnet2-alb"
    Application = "appname"
    Environment = "staging"
  }
}

resource "aws_network_interface" "eni_pvt_subnet2_1" {
  subnet_id       = aws_subnet.subnet2_pvt
  private_ips     = ["10.0.3.68"]
  security_groups = [aws_security_group.SG-for-ECS.id]

  tags = {
    Name        = "staging-eni-pvt-subnet2-ecs"
    Application = "appname"
    Environment = "staging"
  }
}

resource "aws_network_interface" "eni_pvt_subnet_3" {
  subnet_id       = aws_subnet.subnet2_pvt
  private_ips     = ["10.0.3.91"]
  security_groups = [aws_security_group.SG-for-vpc_link.id]

  tags = {
    Name        = "staging-eni-pvt-subnet2-vpclink"
    Application = "appname"
    Environment = "staging"
  }
}
