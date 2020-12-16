variable "region" {
  description = "The AWS Region"
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
