resource "aws_cloudwatch_log_group" "lambda_categories_post" {
  name              = "/aws/lambda/${aws_lambda_function.categories_post.function_name}"
  retention_in_days = var.cw_logs_retention_days
}

resource "aws_cloudwatch_log_group" "lambda_expressions_post" {
  name              = "/aws/lambda/${aws_lambda_function.expressions_post.function_name}"
  retention_in_days = var.cw_logs_retention_days
}
