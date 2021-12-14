environment = "dev"
aws_region  = "eu-central-1"
aws_profile = "tf014"
log_level   = "DEBUG"
domain      = "clashflix.com"
lambda_config = {
  expressions_post = {
    name        = "expressions_post"
    description = "Lambda responsible for create new records in the database"
    handler     = "post.handler"
    arch        = ["arm64"]
    runtime     = "nodejs14.x"
    memory      = 512
    timeout     = 30
  }
}
