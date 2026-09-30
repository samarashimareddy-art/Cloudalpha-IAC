################################################################################
# Application hosting for Cloudalpha-App: ECR + ECS Fargate
#
# This repo creates the place the app runs; the Cloudalpha-App pipeline builds
# the image, pushes it to this ECR repository (tag "latest") and forces a new
# ECS deployment. Until the first image is pushed the service has no image to
# start, which is expected.
#
# The task runs in the public subnet with a public IP (no NAT gateway, to keep
# the demo cheap); its security group only admits the Zscaler egress ranges.
################################################################################

resource "aws_ecr_repository" "app" {
  name                 = "${local.name}-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep the 10 most recent images"
      selection    = { tagStatus = "any", countType = "imageCountMoreThan", countNumber = 10 }
      action       = { type = "expire" }
    }]
  })
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${local.name}-app"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "app" {
  name = "${local.name}-cluster"
}

resource "aws_security_group" "app" {
  name        = "${local.name}-app-sg"
  description = "Cloudalpha demo app - port ${var.app_port} from Zscaler egress ranges only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "App traffic from Zscaler"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    description = "Pull the image from ECR and ship logs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name}-app-sg" }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${local.name}-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_execution_role_arn

  container_definitions = jsonencode([{
    name         = "app"
    image        = "${aws_ecr_repository.app.repository_url}:latest"
    essential    = true
    portMappings = [{ containerPort = var.app_port, protocol = "tcp" }]
    environment  = [{ name = "PORT", value = tostring(var.app_port) }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.app.name
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = "app"
      }
    }
  }])
}

resource "aws_ecs_service" "app" {
  name            = "${local.name}-app"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.app.id]
    assign_public_ip = true
  }

  # The app pipeline redeploys with --force-new-deployment; don't fight it
  # over the running count.
  lifecycle {
    ignore_changes = [desired_count]
  }
}
