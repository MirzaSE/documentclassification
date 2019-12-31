resource "aws_lambda_function" "lambda" {
  filename		   = "${var.lambda_zip_path}"
  function_name    = "${var.function_name}"
  role             = "${var.role}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  timeout		   = "${var.timeout}"
  source_code_hash = "${filesha256("${var.lambda_zip_path}")}"
  memory_size      = "${var.memory}"
	
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = {
      DOCUMENT_CLASSIFICATION_ENDPOINT = "${var.document_classification_endpoint}"     
    }
  }
}
