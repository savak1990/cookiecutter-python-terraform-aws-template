output "api_url" {
  description = "The fully qualified domain name for the API"
  value       = module.api_gateway.custom_domain_name
}

output "api_gateway_url" {
  description = "Invoke URL for the API Gateway"
  value       = module.api_gateway.default_url
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = module.lambda.lambda_function_name
}

output "api_gateway_api_name" {
  description = "Name of the API"
  value       = local.api_gateway_api_name
}
