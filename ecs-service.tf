resource "aws_ecs_service" "service" {
  name            = "environment_service"
  cluster         = aws_ecs_cluster.environment_cluster.id
  task_definition = aws_ecs_task_definition.environment_task.arn
  desired_count   = 2
  depends_on      = [
    aws_iam_role_policy.ECSAppApplicationRole
  ]

network_configuration {
    subnets         = [
        aws_subnet.subnet1, 
        aws_subnet.subnet2
        ]
    security_groups = [
        aws_security_group.SG-for-ECS
        ]
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-2a, us-east-2b]"
  }
}
