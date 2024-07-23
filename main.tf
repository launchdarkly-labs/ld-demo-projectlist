locals {
  demoprojects_fname    = "${var.unique_identifier}_lambda_demoprojects"
  demoprojects_loggroup = "/aws/lambda/${local.demoprojects_fname}"
}

provider "aws" {
  region = var.aws_region
}

provider "archive" {}
