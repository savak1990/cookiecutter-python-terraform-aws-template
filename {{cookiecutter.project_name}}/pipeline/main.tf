provider "aws" {
  region = "{{ cookiecutter.aws_region }}"
}

module "codepipeline" {
  source       = "./modules/codepipeline"
  service_name = "{{ cookiecutter.microservice_name }}"
  root_bucket  = "{{ cookiecutter.artifacts_storage }}"
  secret_name  = "{{ cookiecutter.github_token_aws_secret }}"
  github_repo  = "{{ cookiecutter.github_owner }}/{{ cookiecutter.github_project_name }}"
}

terraform {
  backend "s3" {
    bucket         = "vkdev1-terraform-state"
    key            = "pipeline/{{ cookiecutter.microservice_name }}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "vkdev1-terraform-locks"
    encrypt        = true
  }
}
