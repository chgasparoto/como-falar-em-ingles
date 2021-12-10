data "archive_file" "dynamodb_artefact" {
  type        = "zip"
  output_path = "${path.module}/files/dynamodb.zip"
  source_dir  = "${local.lambdas_path}/dynamodb/src"
}

resource "aws_lambda_function" "dynamodb" {
  function_name = "${local.namespaced_service_name}-${var.lambda_config["dynamodb"].name}"
  description   = var.lambda_config["dynamodb"].description
  role          = aws_iam_role.dynamodb_lambda.arn

  handler       = var.lambda_config["dynamodb"].handler
  architectures = var.lambda_config["dynamodb"].arch
  runtime       = var.lambda_config["dynamodb"].runtime
  timeout       = var.lambda_config["dynamodb"].timeout
  memory_size   = var.lambda_config["dynamodb"].memory

  filename         = data.archive_file.dynamodb_artefact.output_path
  source_code_hash = data.archive_file.dynamodb_artefact.output_base64sha256

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = local.common_lambda_env_vars
  }
}

resource "aws_lambda_permission" "api" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dynamodb.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${local.account_id}:*/*"
}
