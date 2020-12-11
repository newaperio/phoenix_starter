terraform {
  required_version = ">= 0.13"
  # backend "s3" {
  #   bucket = module.tf_remote_state.bucket
  #   key = "base"
  #   region = var.region
  # }
}

provider "aws" {
  version = ">= 2.23.0"
  region  = var.region
  profile = var.aws_profile
}

# module "tf_remote_state" {
#   source      = "github.com/turnerlabs/terraform-remote-state?ref=v4.0.2"

#   role        = var.saml_role
#   application = "${var.env}-${var.customer}-${var.app}"
#   tags        = var.tags
# }

module "base" {
  source      = "../modules/base"

  region      = var.region
  aws_profile = var.aws_profile
  app         = var.app
  env         = var.env
  team        = var.team
  customer    = var.customer
  tags        = var.tags
}

module "fargate" {
  source                     = "git@github.com:newaperio/terraform-modules.git//fargate"

  app                        = var.app
  env                        = var.env
  team                       = var.team
  customer                   = var.customer
  tags                       = var.tags
  private_subnets            = module.base.private_subnets
  public_subnets             = module.base.public_subnets
  vpc_id                     = module.base.vpc_id
  desired_count              = 2
  task_container_environment = {
    POOL_SIZE = 10
    FORCE_SSL = "false"
  }
}

module "db" {
  source                = "git@github.com:newaperio/terraform-modules.git//database/aws"

  env                   = var.env
  app                   = var.app
  team                  = var.team
  name                  = var.app
  username              = var.team
  security_groups       = [module.fargate.security_group]
  vpc_id                = module.base.vpc_id
  database_subnet_group = module.base.database_subnet_group
}

# Route 53
data "aws_route53_zone" "zone" {
  name = var.domain_name
}

resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.app}.${data.aws_route53_zone.zone.name}"
  type    = "A"

  alias {
    name                   = module.fargate.alb_dns_name
    zone_id                = module.fargate.alb_zone_id
    evaluate_target_health = true
  }
}