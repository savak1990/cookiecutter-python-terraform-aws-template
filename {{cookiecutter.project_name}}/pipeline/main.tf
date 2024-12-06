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
