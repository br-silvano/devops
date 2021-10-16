resource "aws_security_group" "lb" {
  name = "lb-sg"
  description = "Allow load balancer traffic"
  vpc_id = var.vpc

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "default" {
  name = "${var.cluster_name}-lb"
  subnets = var.public_subnets
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "hello_world" {
  name = "hello-world-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc
  target_type = "ip"
}

resource "aws_lb_listener" "hello_world" {
  load_balancer_arn = aws_lb.default.id
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.hello_world.id
    type = "forward"
  }
}

resource "aws_ecs_task_definition" "hello_world" {
  family = "hello-world-app"
  execution_role_arn = aws_iam_role.ecs_service_role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = 512
  memory = 1024

  container_definitions = <<DEFINITION
  [
    {
      "image": "heroku/nodejs-hello-world",
      "cpu": 512,
      "memory": 1024,
      "name": "hello-world-app",
      "networkMode": "awsvpc",
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_security_group" "hello_world_task" {
  name = "hello-world-task-sg"
  description = "Allow task traffic"
  vpc_id = var.vpc

  ingress {
    protocol = "tcp"
    from_port = 3000
    to_port = 3000
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_policy" "ecs_service_cloud_watch_metrics_policy" {
  name   = "AmazonECSServiceCloudWatchMetricsPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_service_role" {
  name = "${var.cluster_name}-service-role"
  description = "Allow service to manage fargate task and cloudwatch logs"
  force_detach_policies = true
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ecs-tasks.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy" {
  role = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonECSServiceCloudWatchMetricsPolicy" {
  role = aws_iam_role.ecs_service_role.name
  policy_arn = aws_iam_policy.ecs_service_cloud_watch_metrics_policy.arn
}

resource "aws_cloudwatch_log_group" "log" {
  name = "/aws/ecs/${var.cluster_name}-${var.environment}/cluster"
  retention_in_days = 30
}

resource "aws_ecs_cluster" "main" {
  name = "${var.cluster_name}-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.log.name
      }
    }
  }

  depends_on = [aws_cloudwatch_log_group.log]
}

resource "aws_ecs_service" "hello_world" {
  name = "hello-world-service"
  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.hello_world.arn
  desired_count = var.app_count
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.hello_world_task.id]
    subnets = var.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.hello_world.id
    container_name = "hello-world-app"
    container_port = 3000
  }

  depends_on = [
    aws_lb_listener.hello_world,
    aws_iam_role_policy_attachment.AmazonECSTaskExecutionRolePolicy,
    aws_iam_role_policy_attachment.AmazonECSServiceCloudWatchMetricsPolicy
  ]
}
