
variable "environment" {
  type        = string
  description = "The environment to deploy to"
}

variable "aws_region" {
  type        = string
  description = "The AWS Region to deploy to"
}

variable "service_name" {
  type        = string
  description = "The service name"
  default     = "como-falar-em-ingles"
}

variable "log_level" {
  type        = string
  description = "The level that the logs should be logged"
  default     = "INFO"
}
