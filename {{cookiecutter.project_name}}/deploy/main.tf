provider "aws" {
  region = "{{ cookiecutter.aws_region }}"
}

module "{{ cookiecutter.microservice_name }}" {
  source   = "../terraform"
  api_name = "{{ cookiecutter.microservice_name }}"
  path     = "hello"
  stage    = "dev"
}
