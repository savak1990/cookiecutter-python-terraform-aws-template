variable "api_name" {
  description = "Name of the API Gateway"
}

variable "path" {
  description = "Path part for the API resource"
}

variable "http_method" {
  description = "HTTP method for the API Gateway"
  default     = "GET"
}

variable "lambda_arn" {
  description = "ARN of the Lambda function"
}

variable "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
}

variable "stage_name" {
  description = "Stage name for API Gateway deployment"
  default     = "v1"
}

variable "root_domain_name" {
  description = "Domain name of the API"
  type        = string
}
