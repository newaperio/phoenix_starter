variable "region" {
  default = "us-east-1"
  description = "The AWS Region"
}

variable "aws_profile" {
  description = "Name of the AWS Profile to use. Equivalent of the AWS_PROFILE env variable."
}

variable "app" {
  description = "Name of the application"
}

variable "env" {
  description = "The environment for this deployment"
  default = "staging"
}

variable "team" {
  description = "The team responsible"
}

variable "customer" {
  description = "The customer for this application"
}

variable "tags" {
  type = map(string)
  description = "map of tags to apply to resources created by this manifest."
  default = {
    Terraform="true"
  }
}

variable "private_subnets" {
  description = "The subnets to connect the fargate instance to"
}

variable "public_subnets" {
  description = "The subnets to connect the fargate instance to"
}


variable "cpu" {
  description = "The CPU count for each task instance"
  default = 256
}

variable "memory" {
  description = "The amount of RAM to dedicate to each task instance"
  default = 512
}

variable "container_image" { 
  description = "The container image to deploy"
}

variable "vpc_id" {
  description = "The VPC ID where the cluster will deploy to."
}