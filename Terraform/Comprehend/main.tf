provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket}"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "file_upload" {
  bucket = "${aws_s3_bucket.bucket.id}"
  key    = "${var.bucket_key}"
  source = "${var.source_path}"
  etag   = "${filemd5("${var.source_path}")}"

}

resource "aws_iam_role" "role" {
  name = "AmazonComprehendServiceRole-AssumeRole"
  description = "Grant permission to Cmprehend to deliver logs related to create Classifier"
  #permissions_boundary ="${var.permissions_boundary_arn}"

assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "comprehend.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "comprehend_role" {
  name        = "AmazonComprehendServiceRole-Policy"
  role 		= "${aws_iam_role.role.id}"

policy = <<EOF
{
    "Version": "2012-10-17",
     "Statement": [
        {
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "${aws_s3_bucket.bucket.arn}/*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${aws_s3_bucket.bucket.arn}"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}




resource "null_resource" "create_classifier" {
provisioner "local-exec" {
    command = "aws comprehend create-document-classifier --region ${var.region} --document-classifier-name ${var.classifier_name} --language-code en --input-data-config S3Uri='s3://${var.bucket}/${aws_s3_bucket_object.file_upload.id}' --data-access-role-arn ${aws_iam_role.role.arn}"
  }
  }
  
resource "null_resource" "create_endpoint" {
provisioner "local-exec" {
    command = "aws comprehend create-endpoint --endpoint-name ${var.endpoint} --model-arn 'arn:aws:comprehend:${var.region}:${var.account_id}:document-classifier/${var.classifier_name}' --desired-inference-units 2"
  }
  }

