variable "project" {
  description 	= "Project name for tags and resource naming"
  default 		= "DocumentClassification"
}

variable "source_path" {
  description 	= "File for upload"
  default 		= "Uploads/Test-Small-CSV.csv"
}

variable "bucket_key" {
  description 	= "Cost Center tag"
  default 		= "classification-bucket-key.csv"
}

variable "bucket" {
  description 	= "New bucket name"
  default 		= "classification-bucket"
}

variable "region" {
  description 	= "Region in which to deploy the API"
  default		= "us-east-1"
}

variable "classifier_name" {
  description 	= "Region in which to deploy the API"
  default		= "DocumentClassificator1"
}

variable "endpoint" {
  description 	= "Endpoint for classifier"
  default		= "DocumentClassificatorEndpoint"
}

variable "account_id" {
  description 	= "Account ID needed to construct ARN to allow API Gateway to invoke lambda function"
  default 		= 860839473894 
}

