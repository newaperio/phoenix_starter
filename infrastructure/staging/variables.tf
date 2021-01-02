variable "region" {
  default     = "us-east-1"
  description = "The AWS Region"
}

variable "saml_role" {
  description = "Name of the role that has access to TFState"
}

variable "app" {
  description = "Name of the application"
}

variable "env" {
  description = "The environment for this deployment"
  default     = "staging"
}

variable "team" {
  description = "The team responsible"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to apply to resources created by this manifest."
  default     = {}
}

variable "domain_name" {
  type        = string
  description = "The name of the hosted zone for Route53"
}

variable "email_from" {
  type        = list(string)
  description = "Email addresses to send mail from"
}

variable "dmarc_rua" {
  type = string
  description = "The email address for DMARC reporting"
}
