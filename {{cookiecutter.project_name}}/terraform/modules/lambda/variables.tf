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

variable "log_level" {
  description = "Log level to use for the lambda: debug, info, error"
  type        = string
  default     = "info"
  validation {
    condition     = contains(["debug", "info", "warning", "error"], var.log_level)
    error_message = "Unsupported log_level. Must be one of debug, info, warning, error"
  }
}
