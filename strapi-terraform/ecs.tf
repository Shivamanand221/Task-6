resource "aws_ecs_cluster" "strapi" {
  name = "strapi-cluster"
}

# resource "aws_cloudwatch_log_group" "ecs_strapi" {
#   name = "/ecs/strapi"
# }

resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn = data.aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "shivamanand221/strapi:latest"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
          protocol      = "tcp"
        }
      ]
      environment = [
      {
        name  = "APP_KEYS"
        value = "d16c3ea9e3948146a15d1ea543538fa4e67e8437aaae6a14f34986a308ba8cd9,f1a9d2a9c32207a3499485ff66c6af6862a1080cba8e5999dbd9d31d2f69d82c"
      },
      {
        name  = "NODE_ENV"
        value = "production"
      },
      {
        name  = "ADMIN_JWT_SECRET"
        value = "Jxzshlt7HKg0ZxNhoGJthA=="
      },
      {
        name  = "API_TOKEN_SALT"
        value = "8xZ6eR8Y0F6J12xas+5LHg=="
      },
      {
        name  = "TRANSFER_TOKEN_SALT"
        value = "BmKOus2oWxIJMY9DUf5eXA=="
      },
      {
        name  = "ENCRYPTION_KEY"
        value = "Ob0xsmOsx4WrAL4Ta7xsFsHyvChDyN9Y1ohyTHU728w="
      },
      {
        name  = "FLAG_NPS"
        value = "true"
      },
      {
        name  = "FLAG_PROMOTE_EE"
        value = "true"
      }

    ]
      logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/strapi"
        awslogs-region        = "us-east-1"
        awslogs-stream-prefix = "ecs"
      }
    }
    }
  ])
  # depends_on = [
  #     aws_cloudwatch_log_group.ecs_strapi
  # ]
}
resource "aws_ecs_service" "strapi" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.strapi.id
  task_definition = aws_ecs_task_definition.strapi.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.public.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_policy_attach
  ]
}