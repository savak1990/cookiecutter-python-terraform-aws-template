locals {
  api_env_name         = "${var.api_name}-${var.env}"
  lambda_function_name = "${local.api_env_name}-function"
  api_gateway_api_name = "${local.api_env_name}-api"
}

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
  zip_file      = var.lambda_zip_file
  function_name = local.lambda_function_name
  role_arn      = module.iam.role_arn
  handler       = "handler.handler"
  runtime       = "python3.9"
  log_level     = var.log_level
}

module "api_gateway" {
  source            = "./modules/api_gateway"
  api_name          = local.api_gateway_api_name
  path              = var.path
  lambda_arn        = module.lambda.lambda_arn
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  root_domain_name  = var.domain_name
}
