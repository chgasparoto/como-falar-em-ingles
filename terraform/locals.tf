
locals {
  account_id  = data.aws_caller_identity.current.account_id
  caller_arn  = data.aws_caller_identity.current.arn
  caller_user = data.aws_caller_identity.current.user_id

  namespaced_service_name = "${var.service_name}-${var.environment}"

  lambdas_path = "${path.module}/../backend/lambdas"
  layers_path  = "${path.module}/../backend/lambda-layers"

  is_prod = var.environment == "prod"

  sub_domain_name  = "api.${var.domain}"
  regional_domain  = module.website.regional_domain_name
  website_filepath = "${path.module}/../frontend"

  common_lambda_env_vars = {
    LOG_LEVEL                           = var.log_level
    NODE_ENV                            = var.environment
    ENVIRONMENT                         = var.environment
    AWS_NODEJS_CONNECTION_REUSE_ENABLED = 1
    DYNAMO_DB_TABLE_NAME                = aws_dynamodb_table.this.name
  }
}
