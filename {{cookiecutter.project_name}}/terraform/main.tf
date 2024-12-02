module "iam" {
  source             = "./modules/iam"
  role_name          = "${var.api_name}-role"
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

module "lambda" {
  source        = "./modules/lambda"
  zip_file      = "${path.module}/../build/${var.api_name}.zip"
  function_name = "${var.api_name}-function"
  role_arn      = module.iam.role_arn
  handler       = "handler.handler"
  runtime       = "python3.9"
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  api_name          = "${var.api_name}-api"
  path              = var.path
  lambda_arn        = module.lambda.lambda_arn
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  stage_name        = var.stage
}
