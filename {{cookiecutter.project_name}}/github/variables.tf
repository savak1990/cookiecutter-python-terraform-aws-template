variable "github_token" {
  description = "GitHub token for authentication"
  type        = string
  sensitive   = true
  default     = ""
}

variable "github_token_aws_secret" {
  description = "The name of the AWS Secrets Manager secret that stores the GitHub token"
  type        = string
}

variable "github_owner" {
  description = "The name of github owner"
  type        = string
}

variable "github_repo_name" {
  description = "The name of the GitHub repository to create"
  type        = string
}
