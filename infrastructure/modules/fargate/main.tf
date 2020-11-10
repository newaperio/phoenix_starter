resource "aws_ecs_cluster" "cluster" {
  name = "${var.env}-${var.app}-cluster"

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

module "ecs-fargate" {
  source = "umotif-public/ecs-fargate/aws"
  version = "~> 5.0.0"

  name_prefix        = "${var.env}-${var.app}"
  vpc_id             = var.vpc_id
  private_subnet_ids = var.subnets
  lb_arn             = "arn:aws:asdasdasdasdasdasad"

  cluster_id         = aws_ecs_cluster.cluster.id

  task_container_image   = var.container_image
  task_definition_cpu    = var.cpu
  task_definition_memory = var.memory

  task_container_port             = 80

  health_check = {
    port = "80"
    path = "/health"
  }

  tags = {
    Environment = "test"
    Project = "Test"
  }
}