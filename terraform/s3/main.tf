    terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

locals {
  bucket_names = [
    "customer360-raw-${var.env}",
    "customer360-curated-${var.env}",
    "customer360-analytics-${var.env}"
  ]
}

# --- Create Buckets ---
resource "aws_s3_bucket" "data_lake" {
  for_each      = toset(local.bucket_names)
  bucket        = each.key
  force_destroy = false

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    project      = "customer360"
    environment  = var.env
    owner        = "mish"
    cost-center  = "analytics"
    zone         = split("-", each.key)[1]
  }
}

# --- Versioning ---
resource "aws_s3_bucket_versioning" "versioning" {
  for_each = aws_s3_bucket.data_lake
  bucket   = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}

# --- Encryption ---
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  for_each = aws_s3_bucket.data_lake
  bucket   = each.value.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# --- Lifecycle Rules ---
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  for_each = aws_s3_bucket.data_lake
  bucket   = each.value.id

  rule {
    id     = "lifecycle"
    status = "Enabled"

    filter {
      
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

# --- Block Public Access ---
resource "aws_s3_bucket_public_access_block" "block" {
  for_each = aws_s3_bucket.data_lake
  bucket   = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "data_lake_buckets" {
  value = [for b in aws_s3_bucket.data_lake : b.bucket]
}
