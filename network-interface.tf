resource "aws_network_interface" "eni_pvt_subnet_1" {
  subnet_id       = aws_subnet.subnet1_pvt.id
  private_ips     = ["10.118.128.45"]
  security_groups = [aws_security_group.SG-for-ALB.id]

  tags = {
    Name        = "staging-eni-pvt-subnet1-alb"
    Application = "appname"
    Environment = "staging"
  }
}

resource "aws_network_interface" "eni_pvt_subnet_2" {
  subnet_id       = aws_subnet.subnet1_pvt.id
  private_ips     = ["10.118.128.83"]  # Corrigido para um IP válido em subnet1_pvt
  security_groups = [aws_security_group.SG-for-ECS.id]

  tags = {
    Name        = "staging-eni-pvt-subnet1-ecs"
    Application = "appname"
    Environment = "staging"
  }
}

resource "aws_network_interface" "eni_pvt_subnet_3" {
  subnet_id       = aws_subnet.subnet1_pvt.id
  private_ips     = ["10.118.128.34"]
  security_groups = [aws_security_group.SG-for-vpc_link.id]

  tags = {
    Name        = "staging-eni-pvt-subnet1-vpclink"
    Application = "appname"
    Environment = "staging"
  }
}

resource "aws_network_interface" "eni_pvt_subnet2_1" {
  subnet_id       = aws_subnet.subnet2_pvt.id
  private_ips     = ["10.118.135.72"]
  security_groups = [aws_security_group.SG-for-ALB.id]

  tags = {
    Name        = "staging-eni-pvt-subnet2-alb"
    Application = "appname"
    Environment = "staging"
  }
}

resource "aws_network_interface" "eni_pvt_subnet2_2" {
  subnet_id       = aws_subnet.subnet2_pvt.id
  private_ips     = ["10.118.135.113"]
  security_groups = [aws_security_group.SG-for-ECS.id]

  tags = {
    Name        = "staging-eni-pvt-subnet2-ecs"
    Application = "appname"
    Environment = "staging"
  }
}

resource "aws_network_interface" "eni_pvt_subnet2_3" {
  subnet_id       = aws_subnet.subnet2_pvt.id
  private_ips     = ["10.118.135.66"]
  security_groups = [aws_security_group.SG-for-vpc_link.id]

  tags = {
    Name        = "staging-eni-pvt-subnet2-vpclink"
    Application = "appname"
    Environment = "staging"
  }
}
