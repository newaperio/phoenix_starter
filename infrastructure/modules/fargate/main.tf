data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

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

  name_prefix                = var.app
  vpc_id                     = var.vpc_id
  private_subnet_ids         = var.private_subnets
  lb_arn                     = module.alb.arn

  cluster_id                 = aws_ecs_cluster.cluster.id

  force_new_deployment       = true

  task_container_image       = "${aws_ecr_repository.ecr.repository_url}:${var.task_container_tag}"
  task_definition_cpu        = var.cpu
  task_definition_memory     = var.memory
  task_container_environment = {
    APP_ENV            = var.env
    APP_NAME           = var.app
    AWS_DEFAULT_REGION = data.aws_region.current.name
  }

  task_container_port        = 80

  health_check = {
    port = "80"
    path = "/"
  }

  tags = {
    Terraform   = true
    Environment = var.env
    Application = var.app
  }

  service_registry_arn       = aws_service_discovery_service.service.arn

  depends_on = [
    module.alb
  ]
}

module "alb" {
  source = "umotif-public/alb/aws"
  version = "~> 1.2.1"

  name_prefix = "${var.env}-${var.app}"

  load_balancer_type = "application"

  internal = false
  vpc_id             = var.vpc_id
  subnets            = var.public_subnets

  tags = {
    Terraform   = true
    Environment = var.env
    Application = var.app
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

resource "aws_iam_role_policy" "task_role_ssm" {
  name   = "${var.app}-ssm-read"
  role   = module.fargate.task_role_name
  policy = data.aws_iam_policy_document.ssm_read.json
}