data "aws_iam_policy_document" "apigw_assume_role" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    sid     = "AssumeRolePolicy"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "dynamodb_crud_policy" {

  statement {
    sid = "dynamodbtablepolicy"

    effect = "Allow"

    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]

    resources = [
      aws_dynamodb_table.books.arn,
    ]
  }
}

data "template_file" "books_api" {

  template = file("${path.module}/openapi.yml")

  vars = {
    aws_region       = var.aws_region
    books_table_name = aws_dynamodb_table.books.name
    apigw_role_arn   = aws_iam_role.api_role.arn
  }
}