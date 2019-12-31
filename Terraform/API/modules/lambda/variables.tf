variable "function_name" {
  description = "The name of the lambda function"
}

variable "runtime" {
  description 	= "The runtime of the lambda to create"
}

variable "timeout" {
  description 	= "The timeout of the lambda"
  default 		= 25
}

variable "lambda_zip_path" {
  description 	= "Lambda Function Zipfile local path for S3 Upload"
  default 		= "dist/AWSLambda1.zip"
}

variable "handler" {
  description = "The handler name of the lambda function"
}

variable "memory" {
  description = "The memory size of the lambda function"
}

variable "role" {
  description = "IAM role attached to the Lambda Function (ARN)"
}

variable "document_classification_endpoint" {
  description = "Document Classification ARN Endpoint" 
}

variable "subnet_ids" {
  description = "Which subnets to associate with lambda"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Which security groups to associate with lambda"
  type        = list(string)
}
