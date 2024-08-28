resource "aws_ecs_service" "ecs_service" {
  name            = "environment_service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2
  depends_on = [
    aws_iam_role_policy.ecs_role_policy
  ]

  force_new_deployment = true

  network_configuration {
    subnets = [
      aws_subnet.subnet1_pvt.id,
      aws_subnet.subnet2_pvt.id
    ]
    security_groups = [
      aws_security_group.SG-for-ECS.id
    ]
  }

  placement_constraints {
    type       = "distinctInstance"
    expression = "attribute:ecs.availability-zone in [us-east-2a, us-east-2b]"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "my-container"
    container_port   = "80"
  }

}
