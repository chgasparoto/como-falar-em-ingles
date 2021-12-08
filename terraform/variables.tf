
variable "environment" {
  type        = string
  description = "The environment to deploy to"
}

variable "aws_region" {
  type        = string
  description = "The AWS Region to deploy to"
}

variable "aws_profile" {
  type        = string
  description = "The AWS Profile to use to execute the Terraform commands"
  default     = "default"
}

variable "service_name" {
  type        = string
  description = "The service name"
  default     = "como-falar-em-ingles"
}

variable "domain" {
  type        = string
  description = "The accessible domain for the final users"
  default     = ""
}

variable "log_level" {
  type        = string
  description = "The level that the logs should be logged"
  default     = "INFO"
}
