terraform {
  required_version = ">= 0.13"
  backend "s3" {
    bucket = module.tf_remote_state.bucket
    key = global
  }
}

provider "aws" {
  version = ">= 2.23.0"
  region  = var.region
  profile = var.aws_profile
}

module "tf_remote_state" {
  source = "github.com/turnerlabs/terraform-remote-state?ref=v4.0.2"

  role        = "bootstrapper"
  application = "${var.env}-bootstrap"
  tags        = {
      "Terraform" = "true"
      "Environment" = var.env
  }
}