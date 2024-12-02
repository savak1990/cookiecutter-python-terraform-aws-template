output "api_url" {
  description = "Invoke URL for the API Gateway"
  value       = module.api_gateway.api_url
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = module.lambda.lambda_function_name
}
