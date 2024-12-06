variable "service_name" {
  description = "The name of the microservice."
  type        = string
}

variable "root_bucket" {
  description = "The name of the root S3 bucket for artifacts."
  type        = string
}

variable "secret_name" {
  description = "Name in AWS Secrets Manager where github token resides"
}

variable "github_repo" {
  description = "GitHub repository in the format 'owner/repo'"
  type        = string
}
