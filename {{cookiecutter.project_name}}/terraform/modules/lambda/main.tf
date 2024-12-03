resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7

  lifecycle {
    ignore_changes = [name]
  }
}

resource "aws_lambda_function" "lambda" {
  filename         = var.zip_file
  function_name    = var.function_name
  role             = var.role_arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = filebase64sha256(var.zip_file)

  environment {
    variables = {
      LOG_LEVEL = var.log_level
    }
  }
}
