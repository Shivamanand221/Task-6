resource "aws_ecs_task_definition" "postgres" {
  family                   = "postgres-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "postgres"
      image     = "postgres:14"
      essential = true
      portMappings = [
        {
          containerPort = 5432
        }
      ],
      environment = [
        { name = "POSTGRES_DB", value = "strapi" },
        { name = "POSTGRES_USER", value = "strapi" },
        { name = "POSTGRES_PASSWORD", value = "strapi" }
      ]
    }
  ])
}

resource "aws_ecs_service" "postgres" {
  name            = "postgres-service"
  cluster         = aws_ecs_cluster.strapi.id
  launch_type     = "FARGATE"
  desired_count   = 1
  task_definition = aws_ecs_task_definition.postgres.arn

  network_configuration {
    subnets         = [aws_subnet.public.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs.id]
  }
}

resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "shivamanand221/strapi:latest"
      essential = true
      portMappings = [
        {
          containerPort = 1337
        }
      ],
      environment = [
        { name = "DATABASE_CLIENT", value = "postgres" },
        { name = "DATABASE_HOST", value = "postgres-service" }, # DNS of ECS service
        { name = "DATABASE_PORT", value = "5432" },
        { name = "DATABASE_NAME", value = "strapi" },
        { name = "DATABASE_USERNAME", value = "strapi" },
        { name = "DATABASE_PASSWORD", value = "strapi" }
      ]
    }
  ])
}

resource "aws_service_discovery_private_dns_namespace" "ecs" {
  name        = "ecs.local"
  vpc         = aws_vpc.main.id
  description = "Private namespace for ECS services"
}

resource "aws_service_discovery_service" "postgres" {
  name = "postgres-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs.id
    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }
}
