terraform {
  required_version = ">= 0.14"
  # backend "s3" {
  #   bucket = module.tf_remote_state.bucket
  #   key = "base"
  #   region = var.region
  # }
}

provider "aws" {
  region  = var.region
}

# module "tf_remote_state" {
#   source      = "github.com/turnerlabs/terraform-remote-state?ref=v4.0.2"

#   role        = var.saml_role
#   application = "${var.env}-${var.customer}-${var.app}"
#   tags        = var.tags
# }

module "base" {
  source = "git@github.com:newaperio/terraform-modules.git//base"

  region      = var.region
  app         = var.app
  env         = var.env
  team        = var.team
  customer    = var.customer
  tags        = merge({
    Terraform   = "true"
    environment = var.env
    app         = var.app
    team        = var.team
    customer    = var.customer
  }, var.tags)
}

module "fargate" {
  source = "git@github.com:newaperio/terraform-modules.git//fargate"

  app             = var.app
  env             = var.env
  team            = var.team
  customer        = var.customer
  private_subnets = module.base.private_subnets
  public_subnets  = module.base.public_subnets
  vpc_id          = module.base.vpc_id
  desired_count   = 2

  task_container_environment = {
    POOL_SIZE = 10
    APP_HOST  = data.aws_route53_zone.zone.name
  }

  certificate     = module.acm.this_acm_certificate_arn

  tags = merge({
    Terraform   = "true"
    environment = var.env
    app         = var.app
    team        = var.team
    customer    = var.customer
  }, var.tags)
}

module "db" {
  source = "git@github.com:newaperio/terraform-modules.git//database/aws"

  env                   = var.env
  app                   = var.app
  team                  = var.team
  name                  = var.app
  username              = var.team
  security_groups       = [module.fargate.security_group]
  subnets               = module.base.database_subnets
  vpc_id                = module.base.vpc_id

  tags = merge({
    Terraform   = "true"
    environment = var.env
    app         = var.app
    team        = var.team
    customer    = var.customer
  }, var.tags)
}

# Route 53
data "aws_route53_zone" "zone" {
  name = var.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> v2.12.0"

  domain_name = var.domain_name
  zone_id     = data.aws_route53_zone.zone.zone_id

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  wait_for_validation = true

  tags = merge({
    Name        = var.domain_name
    Terraform   = "true"
    environment = var.env
    app         = var.app
    team        = var.team
    customer    = var.customer
  }, var.tags)
}

resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = data.aws_route53_zone.zone.name
  type    = "A"

  alias {
    name                   = module.fargate.alb_dns_name
    zone_id                = module.fargate.alb_zone_id
    evaluate_target_health = true
  }
}
