terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_lambda_function" "get_todos" {
  function_name = "GetTodos"
  filename      = "lambdas/getTodos.zip"
  handler       = "getTodos.handler"
  runtime       = "nodejs10.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "get_todo_by_id" {
  function_name = "GetTodoById"
  filename      = "lambdas/getTodoById.zip"
  handler       = "getTodoById.handler"
  runtime       = "nodejs10.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "update_todo_by_id" {
  function_name = "UpdateTodoById"
  filename      = "lambdas/updateTodoById.zip"
  handler       = "updateTodoById.handler"
  runtime       = "nodejs10.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "delete_todo_by_id" {
  function_name = "DeleteTodoById"
  filename      = "lambdas/deleteTodoById.zip"
  handler       = "deleteTodoById.handler"
  runtime       = "nodejs10.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "create_todo" {
  function_name = "CreateTodo"
  filename      = "lambdas/createTodo.zip"
  handler       = "createTodo.handler"
  runtime       = "nodejs10.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "create_comment" {
  function_name = "CreateComment"
  filename      = "lambdas/createComment.zip"
  handler       = "createComment.handler"
  runtime       = "nodejs10.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "get_comments" {
  function_name = "GetComments"
  filename      = "lambdas/getComments.zip"
  handler       = "getComments.handler"
  runtime       = "nodejs10.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "delete_comment_by_id" {
  function_name = "DeleteCommentById"
  filename      = "lambdas/deleteCommentById.zip"
  handler       = "deleteCommentById.handler"
  runtime       = "nodejs10.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "create_like" {
  function_name = "CreateLike"
  filename      = "lambdas/createLike.zip"
  handler       = "createLike.handler"
  runtime       = "nodejs10.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "get_likes" {
  function_name = "GetLikes"
  filename      = "lambdas/getLikes.zip"
  handler       = "getLikes.handler"
  runtime       = "nodejs10.x"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "delete_like_by_id" {
  function_name = "DeleteLikeById"
  filename      = "lambdas/deleteLikeById.zip"
  handler       = "deleteLikeById.handler"
  runtime       = "nodejs10.x"
  role          = aws_iam_role.lambda_exec.arn
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_exec.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListAndDescribe",
            "Effect": "Allow",
            "Action": [
                "dynamodb:List*",
                "dynamodb:DescribeReservedCapacity*",
                "dynamodb:DescribeLimits",
                "dynamodb:DescribeTimeToLive"
            ],
            "Resource": "*"
        },
        {
            "Sid": "SpecificTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchGet*",
                "dynamodb:DescribeStream",
                "dynamodb:DescribeTable",
                "dynamodb:Get*",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:BatchWrite*",
                "dynamodb:CreateTable",
                "dynamodb:Delete*",
                "dynamodb:Update*",
                "dynamodb:PutItem"
            ],
            "Resource": [
              "arn:aws:dynamodb:*:*:table/${var.todos_table_name}",
              "arn:aws:dynamodb:*:*:table/${var.comments_table_name}",
              "arn:aws:dynamodb:*:*:table/${var.todos_table_name}/index/*",
              "arn:aws:dynamodb:*:*:table/${var.comments_table_name}/index/*",
              "arn:aws:dynamodb:*:*:table/${var.likes_table_name}",
              "arn:aws:dynamodb:*:*:table/${var.likes_table_name}/index/*"
            ]
        }
    ]
}
EOF
}







