resource "aws_api_gateway_rest_api" "api" {
  name           = "${local.app_prefix}${terraform.workspace}-api"
  description    = "Books API"
  api_key_source = "HEADER"
  body           = data.template_file.books_api.rendered

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = terraform.workspace
}

resource "aws_iam_role" "api_role" {
  name               = "${local.app_prefix}${terraform.workspace}-api-role"
  assume_role_policy = data.aws_iam_policy_document.apigw_assume_role.json
}

resource "aws_iam_policy" "api_dynamodb_policy" {
  name   = "${local.app_prefix}${terraform.workspace}-dynamodb-crud-policy"
  policy = data.aws_iam_policy_document.dynamodb_crud_policy.json
}

resource "aws_iam_role_policy_attachment" "api_dynamodb_policy_attachment" {
  role       = aws_iam_role.api_role.name
  policy_arn = aws_iam_policy.api_dynamodb_policy.arn
}

resource "aws_dynamodb_table" "books" {
  name         = "${local.app_prefix}${terraform.workspace}-books"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "book_id"

  attribute {
    name = "book_id"
    type = "S"
  }

  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"
}