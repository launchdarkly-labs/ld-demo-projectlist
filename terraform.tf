terraform {
  backend "s3" {
    bucket         = "demo-projects-state"
    key            = "terraform.tfstate"
    dynamodb_table = "demo-projects-state"
    region         = "us-east-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

resource "aws_s3_bucket" "this" {
  bucket = "demo-projects-state"

  tags = {
    Name        = "state"
    Application = var.app_name
    Maintainer  = var.owner
    CreatedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "this" {
  name         = "demo-projects-state"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "state"
    Application = var.app_name
    Maintainer  = var.owner
    CreatedBy   = "terraform"
  }
}
