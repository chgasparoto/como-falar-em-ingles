data "archive_file" "expressions_artefact" {
  type        = "zip"
  output_path = "${path.module}/files/expressions.zip"
  source_dir  = "${local.lambdas_path}/expressions"
}

resource "aws_lambda_function" "expressions_post" {
  function_name = "${local.namespaced_service_name}-${var.lambda_config["expressions_post"].name}"
  description   = var.lambda_config["expressions_post"].description
  role          = aws_iam_role.expressions_post_lambda.arn

  handler       = var.lambda_config["expressions_post"].handler
  architectures = var.lambda_config["expressions_post"].arch
  runtime       = var.lambda_config["expressions_post"].runtime
  timeout       = var.lambda_config["expressions_post"].timeout
  memory_size   = var.lambda_config["expressions_post"].memory

  filename         = data.archive_file.expressions_artefact.output_path
  source_code_hash = data.archive_file.expressions_artefact.output_base64sha256

  layers = [
    module.layers["utils"].arn,
    module.layers["middy"].arn,
    module.layers["middlewares"].arn,
  ]

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = local.common_lambda_env_vars
  }
}

resource "aws_lambda_permission" "api" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.expressions_post.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${local.account_id}:*/*"
}
