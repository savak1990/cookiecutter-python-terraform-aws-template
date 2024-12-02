variable "api_name" {
  description = "API Name"
  type        = string
}

variable "stage" {
  description = "Stage of API Gateway. Supported values: dev, staging, prod"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.stage)
    error_message = "Invalid stage provided. Supported values are: dev, staging, prod"
  }
}

variable "path" {
  description = "value"
  type        = string
}
