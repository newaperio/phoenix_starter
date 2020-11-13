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
#   source = "github.com/turnerlabs/terraform-remote-state?ref=v4.0.2"

#   role        = var.saml_role
#   application = "${var.env}-${var.customer}-${var.app}"
#   tags        = var.tags
# }

module "base" {
  source = "../modules/base"

  region = var.region
  aws_profile = var.aws_profile
  app = var.app
  env = var.env
  team = var.team
  customer = var.customer
  tags = var.tags
}

module "fargate" {
  source = "../modules/fargate"

  region = var.region
  aws_profile = var.aws_profile
  app = var.app
  env = var.env
  team = var.team
  customer = var.customer
  tags = var.tags
  container_image = var.container_image
  private_subnets = module.base.private_subnets
  public_subnets = module.base.public_subnets
  vpc_id = module.base.vpc_id
}