environment = "prod"
aws_region  = "eu-central-1"
aws_profile = "ggasparoto_macbook"
log_level   = "WARN"
domain      = "comofalaremingles.com"
lambda_config = {
  dynamodb = {
    name        = "dynamodb"
    description = "Just a test lambda"
    handler     = "index.handler"
    arch        = ["arm64"]
    runtime     = "nodejs14.x"
    memory      = 512
    timeout     = 30
  }
}
