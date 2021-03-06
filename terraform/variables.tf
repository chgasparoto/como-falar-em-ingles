
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
}

variable "log_level" {
  type        = string
  description = "The level that the logs should be logged"
  default     = "INFO"
}

variable "lambda_config" {
  description = "Lambdas configuration"

  type = map(object({
    name        = string
    description = string
    handler     = string
    arch        = list(string)
    runtime     = string
    memory      = number
    timeout     = number
  }))
}

variable "cw_logs_retention_days" {
  type        = number
  description = "Number of days to retain the logs in Cloudwatch"
  default     = 3
}
