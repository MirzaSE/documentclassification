provider "aws" {
  region = var.region
}

####################
# VPC
####################
module "vpc_subnets" {
  name                 = "${var.project}-${terraform.workspace}-vpc"
  source               = "./modules/vpc"
  environment          = "${terraform.workspace}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnets_cidr  = "${var.public_subnets_cidr}"
  private_subnets_cidr = "${var.private_subnets_cidr}"
  nat_cidr             = "${var.nat_cidr}"
  igw_cidr             = "${var.igw_cidr}"
  azs                  = "${var.azs}"
  project              = "${var.project}"
  service              = "${var.service}"
  owner                = "${var.owner}"
  costcenter           = "${var.costcenter}"
}

resource "aws_security_group" "all" {
  name = "all"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc_subnets.vpc_id
 
  tags  = {    
    "Environment" = "${terraform.workspace}"
    "Project"     = "${var.project}"
    "Owner"       = "${var.owner}"
    "CostCenter"  = "${var.costcenter}"
    "managed_by"  = "terraform"
    "service"     = "${var.service}"
  }
}

####################
# API
####################
module "api" {
  source     = "./modules/api"
  
  name       = "${module.lambda.name}"  
  method     = "GET"
  lambda     = "${module.lambda.name}"
  lambda_arn = "${module.lambda.arn}"
  region     = "${var.region}"
  account_id = "${var.account_id}"
  stage_name = "${terraform.workspace}"
}

####################
# Lambda
####################
module "lambda" {
  source        					= "./modules/lambda"
  
  lambda_zip_path  					= "${var.lambda_zip_path}"
  #hash          					= "${data.aws_s3_bucket_object.lambda_dist_hash.etag}"
  function_name 					= "${var.project}-${terraform.workspace}-${var.lambda_function_name}"
  handler       					= "${var.lambda_handler}"
  runtime       					= "${var.lambda_runtime}"
  role          					= "${aws_iam_role.lambda_role.arn}"
  memory        					= "${var.lambda_memory}"
  document_classification_endpoint  = "${var.document_classification_endpoint}"

  # document_classification_endpoint  = "${module.document_classification_endpoint}"

  subnet_ids         = module.vpc_subnets.nat_subnet_id
  security_group_ids = ["${aws_security_group.all.id}"]
}


resource "aws_iam_role" "lambda_role" {
  name = "${var.project}-${terraform.workspace}-${var.lambda_function_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "comprehend" {
  name = "${aws_iam_role.lambda_role.name}-comprehend"
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "comprehend:*",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "iam:ListRoles",
                "iam:GetRole"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "vpc" {
  name = "${aws_iam_role.lambda_role.name}-vpc"
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "logs" {
  name = "${aws_iam_role.lambda_role.name}-logs"
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
