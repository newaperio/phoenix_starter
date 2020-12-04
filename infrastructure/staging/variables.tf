variable "region" {
  default = "us-east-1"
  description = "The AWS Region"
}

variable "aws_profile" {
  description = "Name of the AWS Profile to use. Equivalent of the AWS_PROFILE env variable."
}

variable "saml_role" {
  description = "Name of the role that has access to TFState"
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
