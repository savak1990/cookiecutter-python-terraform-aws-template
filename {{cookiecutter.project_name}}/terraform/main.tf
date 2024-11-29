provider "aws" {
  region = "{{ cookiecutter.aws_region }}"
}

module "iam" {
  source             = "./modules/iam"
  role_name          = "{{ cookiecutter.microservice_name }}-role"
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

module "{{ cookiecutter.microservice_name }}_lambda" {
  source        = "./modules/lambda"
  zip_file      = "${path.module}/../build/{{ cookiecutter.microservice_name }}.zip"
  function_name = "{{ cookiecutter.microservice_name }}-function"
  role_arn      = module.iam.role_arn
  handler       = "handler.handler"
  runtime       = "python3.9"
}

module "{{ cookiecutter.microservice_name }}_api_gateway" {
  source            = "./modules/api_gateway"
  api_name          = "{{ cookiecutter.microservice_name }}-api"
  path              = "hello"
  lambda_arn        = module.{{ cookiecutter.microservice_name }}_lambda.lambda_arn
  lambda_invoke_arn = module.{{ cookiecutter.microservice_name }}_lambda.lambda_invoke_arn
  stage_name        = "dev"
}
