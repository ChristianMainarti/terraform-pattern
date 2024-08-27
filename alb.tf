resource "aws_lb" "alb" {
    internal           = false
    load_balancer_type = "application"
    security_groups    = [
      aws_security_group.SG-for-ALB.id
    ]
    subnets            = [
      aws_subnet.subnet1.id, 
      aws_subnet.subnet2.id
      ]
    
    enable_deletion_protection = true

    tags = {
      name        = "prod-appname-alb-us-east-2"
      Application = "app name"
      Environment = ""
    }
}

resource "aws_lb_target_group" "ecs_tg" {
  name     = "prod"
  port     = 3333
  protocol = "HTTP"
  vpc_id   = aws_vpc.prod-vpc.id

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