data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"

  name               = "${var.app}-vpc"
  cidr               = "10.0.0.0/16"

  azs                = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  tags = {
    terraform   = "true"
    environment = var.env
    app         = var.app
    team        = var.team
    customer    = var.customer
  }
}
