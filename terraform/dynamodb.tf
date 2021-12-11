resource "aws_dynamodb_table" "this" {
  name      = local.namespaced_service_name
  hash_key  = "pk"
  range_key = "sk"

  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "entity_type"
    type = "S"
  }

  global_secondary_index {
    name            = "gsi1"
    hash_key        = "entity_type"
    range_key       = "sk"
    projection_type = "ALL"
  }
}
