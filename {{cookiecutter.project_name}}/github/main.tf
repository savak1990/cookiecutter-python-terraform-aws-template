provider "aws" {
  region = "{{ cookiecutter.aws_region }}"
}

data "aws_secretsmanager_secret" "github_token" {
  name = var.github_token_aws_secret
}

data "aws_secretsmanager_secret_version" "github_token_version" {
  secret_id = data.aws_secretsmanager_secret.github_token.id
}

locals {
  secrets_manager_token = jsondecode(data.aws_secretsmanager_secret_version.github_token_version.secret_string).github_token
}

provider "github" {
  token = coalesce(var.github_token, local.secrets_manager_token)
  owner = var.github_owner
}

resource "github_repository" "repo" {
  name        = var.github_repo_name
  description = "The source code for {{ cookiecutter.microservice_name }} microservice that deploys to AWS Lambda and the code is written in Python"
  visibility  = "public"
  topics      = ["terraform", "github", "microservice", "python", "lambda"]
}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
