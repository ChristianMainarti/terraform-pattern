resource "aws_lb" "alb" {
  internal           = true
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.SG-for-ALB.id
  ]
  subnets = [
    aws_subnet.subnet1_pvt.id,
    aws_subnet.subnet2_pvt.id
  ]

  enable_deletion_protection = true

  tags = {
    name        = "staging-appname-alb-us-east-1"
    Application = "app name"
    Environment = "Staging"
  }
  
}

resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "appname-staging"
  description = "api gateway for app name"
  target_arns = [aws_lb.alb.arn]
}

resource "aws_lb_target_group" "ecs_tg" {
  name     = "staging"
  port     = 3333
  protocol = "HTTP"
  vpc_id   = aws_vpc.staging-vpc.id

  health_check {
    path                = "/health-check"
    interval            = 90
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}