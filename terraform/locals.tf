
locals {
  account_id  = data.aws_caller_identity.current.account_id
  caller_arn  = data.aws_caller_identity.current.arn
  caller_user = data.aws_caller_identity.current.user_id

  namespaced_service_name = "${var.service_name}-${var.environment}"

  common_lambda_env_vars = {
    LOG_LEVEL                           = var.log_level
    NODE_ENV                            = var.environment
    ENVIRONMENT                         = var.environment
    AWS_NODEJS_CONNECTION_REUSE_ENABLED = 1
  }
}
