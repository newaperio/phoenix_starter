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

resource "aws_security_group" "public_security_group" {
  name        = "public_lb"
  description = "Access to the public facing load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    description = "Anywhere on the internet"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "fargate_lb" {
  internal        = false
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.public_security_group.id]
}