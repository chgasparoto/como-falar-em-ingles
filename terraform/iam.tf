data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "dynamodb" {
  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "xray:PutTraceSegments"
    ]
  }
}

resource "aws_iam_role" "dynamodb_lambda" {
  # substr function to avoid error on the length of the IAM role name
  name               = substr("${local.namespaced_service_name}-dynamodb-lambda-role", 0, 64)
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "dynamodb" {
  name   = substr("${local.namespaced_service_name}-dynamodb-policy", 0, 64)
  policy = data.aws_iam_policy_document.dynamodb.json
}

resource "aws_iam_role_policy_attachment" "dynamodb" {
  policy_arn = aws_iam_policy.dynamodb.arn
  role       = aws_iam_role.dynamodb_lambda.name
}

### Expressions post

data "aws_iam_policy_document" "expressions_post" {
  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "dynamodb:ListTables",
      "xray:PutTraceSegments"
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:${var.aws_region}:${local.account_id}:table/${aws_dynamodb_table.this.name}"]
    actions = [
      "dynamodb:PutItem",
      "dynamodb:DescribeTable"
    ]
  }
}

resource "aws_iam_role" "expressions_post_lambda" {
  # substr function to avoid error on the length of the IAM role name
  name               = substr("${local.namespaced_service_name}-expression_post-lambda-role", 0, 64)
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "expressions_post" {
  name   = substr("${local.namespaced_service_name}-expressions_post-policy", 0, 64)
  policy = data.aws_iam_policy_document.expressions_post.json
}

resource "aws_iam_role_policy_attachment" "expressions_post" {
  policy_arn = aws_iam_policy.expressions_post.arn
  role       = aws_iam_role.expressions_post_lambda.name
}
