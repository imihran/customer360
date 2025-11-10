// -----------------------------------------------------------------------------
// main.tf
// This file defines the Terraform configuration for creating and managing S3
// buckets used in the data lake architecture. It includes bucket creation,
// versioning, and tagging to ensure proper organization and lifecycle management.
// -----------------------------------------------------------------------------

// Specify the required providers and their versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

// Configure the AWS provider with profile and region
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

// Define local variables for bucket names
locals {
  bucket_names = [
    "customer360-raw-${var.env}",       // Raw data bucket
    "customer360-curated-${var.env}",   // Curated data bucket
    "customer360-analytics-${var.env}" // Analytics data bucket
  ]
}

// Create S3 buckets for the data lake
resource "aws_s3_bucket" "data_lake" {
  for_each      = toset(local.bucket_names) // Iterate over bucket names
  bucket        = each.key                  // Set bucket name
  force_destroy = false                     // Prevent accidental deletion

  lifecycle {
    prevent_destroy = false // Allow bucket deletion if needed
  }

  tags = {
    project      = "customer360"          // Project name
    environment  = var.env                 // Deployment environment
    owner        = var.owner              // Owner of the bucket
    cost-center  = "analytics"           // Cost center for billing
    zone         = split("-", each.key)[1] // Extract zone from bucket name
  }
}

// Enable versioning for the S3 buckets
resource "aws_s3_bucket_versioning" "versioning" {
  for_each = aws_s3_bucket.data_lake       // Apply versioning to all buckets
  bucket   = each.value.id                 // Reference bucket ID
  versioning_configuration {
    status = "Enabled"                    // Enable versioning
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
    
    filter{}

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
