resource "aws_cloudwatch_log_group" "lambda_dynamodb" {
  name              = "/aws/lambda/${aws_lambda_function.dynamodb.function_name}"
  retention_in_days = var.cw_logs_retention_days
}
