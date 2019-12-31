####################
# Tags
####################
variable "project" {
  description 	= "Project name for tags and resource naming"
  default 		= "Document-classification"
}

variable "owner" {
  description 	= "Contact person responsible for the resource"
  default 		= "mirza.dev"
}

variable "costcenter" {
  description 	= "Cost Center tag"
  default 		= "acme-abc"
}

variable "service" {
  description 	= "Service name"
  default 		= "acme-corp"
}

####################
# VPC
####################
variable vpc_cidr {
  description 	= "VPC CIDR"
  default 		= "10.0.0.0/16"
}

variable igw_cidr {
  description 	= "VPC Internet Gateway CIDR"
  default 		= "10.0.8.0/24"
}

variable public_subnets_cidr {
  description 	= "Public Subnets CIDR"
  type        	= list(string)
  default 		= ["10.0.1.0/24", "10.0.2.0/24"]
}

variable private_subnets_cidr {
  description 	= "Private Subnets CIDR"
  type        	= list(string)
  default 		= ["10.0.3.0/24", "10.0.4.0/24"]
}

variable nat_cidr {
  description 	= "VPC NAT Gateway CIDR"
  type        	= list(string)
  default 		= ["10.0.5.0/24", "10.0.6.0/24"]
}

variable azs {
  description 	= "VPC Availability Zones"
  type        	= list(string)
  default 		= ["us-east-1a", "us-east-1b"]
}

####################
# Lambda
####################
variable "lambda_runtime" {
  description 	= "Lambda Function runtime"
  default 		= "dotnetcore2.1"
}

variable "lambda_zip_path" {
  description 	= "Lambda Function Zipfile local path for S3 Upload"
  default 		= "dist/AWSLambda1.zip"
}

variable "lambda_function_name" {
  description 	= "Lambda Function Name"
  default     	= "DocumentClassificator"
}

variable "lambda_handler" {
  description 	= "Lambda Function Handler"
  default 		= "HeavyWater.DocumentClassificator::HeavyWater.DocumentClassificator.Function::FunctionHandler"
}

variable "lambda_memory" {
  description 	= "Lambda memory size, 128 MB to 3,008 MB, in 64 MB increments"
  default 		= "128"
}

variable "document_classification_endpoint" {
  description 	= "Lambda memory size, 128 MB to 3,008 MB, in 64 MB increments"
  default 		= "arn:aws:comprehend:us-east-1:860839473894:document-classifier-endpoint/DocumentClassificator"
}

####################
# API Gateway
####################
variable "region" {
  description 	= "Region in which to deploy the API"
  default		= "us-east-1"
}

variable "account_id" {
  description 	= "Account ID needed to construct ARN to allow API Gateway to invoke lambda function"
  default 		= 860839473894 
}


