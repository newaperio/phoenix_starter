terraform {
  required_version = ">= 0.13"
}

provider "aws" {
  version = ">= 2.23.0"
  region  = var.region
  profile = var.aws_profile
}

module "tf_remote_state" {
  source = "github.com/turnerlabs/terraform-remote-state?ref=v4.0.2"

  role        = var.saml_role
  application = "${var.env}-${var.customer}-${var.app}"
  tags        = var.tags
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.app}-vpc"
  cidr = "10.1.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.101.0/24", "10.1.102.0/24"]

  enable_nat_gateway = true

  tags = {
    terraform = "true"
    environment = var.env
    app = var.app
    team = var.team
    customer = var.customer
  }
}

# Needs security groups

resource "aws_lb" "fargate_lb" {
  subnets = module.vpc.public_subnets
  security_groups = []
}