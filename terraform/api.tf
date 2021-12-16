resource "aws_api_gateway_rest_api" "this" {
  name = local.namespaced_service_name
}

resource "aws_api_gateway_api_key" "this" {
  name = var.environment
}

resource "aws_api_gateway_usage_plan_key" "this" {
  key_id        = aws_api_gateway_api_key.this.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.this.id
}

resource "aws_api_gateway_usage_plan" "this" {
  name = "${local.namespaced_service_name}-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_stage.this.stage_name
  }
}

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "v1"
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  lifecycle {
    create_before_destroy = true
  }

  variables = {
    deployed_at = timestamp()
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.environment
}

resource "aws_api_gateway_domain_name" "this" {
  certificate_arn = aws_acm_certificate_validation.this.certificate_arn
  domain_name     = local.sub_domain_name
}

resource "aws_api_gateway_base_path_mapping" "this" {
  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  domain_name = aws_api_gateway_domain_name.this.domain_name
}

### Create category record in database

resource "aws_api_gateway_resource" "categories" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "categories"
}

resource "aws_api_gateway_method" "categories_post" {
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = aws_api_gateway_resource.categories.id
  authorization    = "NONE"
  http_method      = "POST"
  api_key_required = true
}

resource "aws_api_gateway_integration" "categories_post" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.categories.id
  http_method             = aws_api_gateway_method.categories_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.categories_post.invoke_arn
}

### Create expression record in database

resource "aws_api_gateway_resource" "expressions" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "expressions"
}

resource "aws_api_gateway_method" "expressions_post" {
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = aws_api_gateway_resource.expressions.id
  authorization    = "NONE"
  http_method      = "POST"
  api_key_required = true
}

resource "aws_api_gateway_integration" "expressions_post" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.expressions.id
  http_method             = aws_api_gateway_method.expressions_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.expressions_post.invoke_arn
}
