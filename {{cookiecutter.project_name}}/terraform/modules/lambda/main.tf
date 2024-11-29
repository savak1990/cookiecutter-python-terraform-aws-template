resource "aws_lambda_function" "lambda" {
  filename         = var.zip_file
  function_name    = var.function_name
  role             = var.role_arn
  handler          = var.handler
  runtime          = var.runtime
  source_code_hash = filebase64sha256(var.zip_file)
}
