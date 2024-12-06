variable "api_name" {
  description = "API Name"
  type        = string
}

variable "env" {
  description = "Environment. Supported options: dev, staging, prod"
  type        = string
  default     = "dev"
}

variable "path" {
  description = "value"
  type        = string
}

variable "domain_name" {
  description = "The base domain name (e.g., example.com)"
  default     = "example.com"
  type        = string
}

variable "lambda_zip_file" {
  description = "Path to a zip with the code for lambda"
  type        = string
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
