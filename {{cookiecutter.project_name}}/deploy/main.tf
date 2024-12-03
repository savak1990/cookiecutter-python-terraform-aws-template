provider "aws" {
  region = "{{ cookiecutter.aws_region }}"
}

module "{{ cookiecutter.microservice_name }}" {
  source          = "../terraform"
  api_name        = "{{ cookiecutter.microservice_name.replace("_", "-") }}"
  lambda_zip_file = "${path.module}/../build/{{ cookiecutter.microservice_name }}.zip"
  path            = "hello"
  stage           = "v1"
  env             = "dev"
  domain_name     = "{{ cookiecutter.domain_name }}"
  log_level       = "debug"
}
