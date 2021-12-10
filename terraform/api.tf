resource "aws_api_gateway_rest_api" "this" {
  name = local.namespaced_service_name
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = local.namespaced_service_name
      version = "1.0"
    }
    paths = {
      "/user" = {
        get = {
          x-amazon-apigateway-integration = {
            "type" : "aws_proxy",
            "httpMethod" : "POST",
            "uri" : aws_lambda_function.dynamodb.invoke_arn,
            "responses" : {
              "default" : {
                "statusCode" : "200"
              }
            },
            "passthroughBehavior" : "when_no_match",
            "contentHandling" : "CONVERT_TO_TEXT"
          }
        }
      }
    }
  })
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
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
