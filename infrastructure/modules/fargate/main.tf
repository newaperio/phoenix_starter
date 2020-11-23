resource "aws_ecs_cluster" "cluster" {
  name = var.app

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

module "fargate" {
  source = "umotif-public/ecs-fargate/aws"
  version = "~> 5.0.0"

  name_prefix            = var.app
  vpc_id                 = var.vpc_id
  private_subnet_ids     = var.private_subnets
  lb_arn                 = module.alb.arn

  cluster_id             = aws_ecs_cluster.cluster.id

  task_container_image   = var.container_image
  task_definition_cpu    = var.cpu
  task_definition_memory = var.memory

  task_container_port    = 80

  health_check = {
    port = "80"
    path = "/health"
  }

  tags = {
    Environment = "test"
    Project = "Test"
  }

  depends_on = [
    module.alb
  ]
}

module "alb" {
  source = "umotif-public/alb/aws"
  version = "~> 1.2.1"

  name_prefix = "complete-alb"

  load_balancer_type = "application"

  internal = false
  vpc_id             = var.vpc_id
  subnets            = var.public_subnets

  tags = {
    Terraform = "true"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = module.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = module.fargate.target_group_arn
  }
}

resource "aws_security_group_rule" "alb_ingress_80" {
  security_group_id = module.alb.security_group_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "task_ingress_80" {
  security_group_id        = module.fargate.service_sg_id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = module.alb.security_group_id
}

resource "aws_ecr_repository" "ecr" {
  name                 = "${var.env}-${var.app}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}