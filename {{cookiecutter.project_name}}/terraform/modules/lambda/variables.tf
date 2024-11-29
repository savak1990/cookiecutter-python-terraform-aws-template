variable "zip_file" {
  description = "Path to the Lambda deployment package"
}

variable "function_name" {
  description = "Name of the Lambda function"
}

variable "role_arn" {
  description = "IAM role ARN for the Lambda function"
}

variable "handler" {
  description = "Handler for the Lambda function"
  default     = "handler.handler"
}

variable "runtime" {
  description = "Runtime for the Lambda function"
  default     = "python3.9"
}
