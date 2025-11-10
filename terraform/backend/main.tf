// -----------------------------------------------------------------------------
// main.tf
// This file contains the main Terraform configuration for setting up the
// backend infrastructure. It includes the definition of the AWS provider,
// S3 bucket for Terraform state storage, and associated configurations such as
// public access restrictions and versioning. These resources ensure secure and
// reliable state management for the infrastructure.
// -----------------------------------------------------------------------------

// Configure the required Terraform version and providers
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

// Define the AWS provider configuration using variables for profile and region
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

// Create an S3 bucket to store Terraform state files
resource "aws_s3_bucket" "tf_state" {
  bucket        = "customer360-tfstate-${var.env}"
  force_destroy = false

#   lifecycle {
#     prevent_destroy = true
#   }

  tags = {
    project      = "customer360" // Project name
    environment  = var.env       // Deployment environment (e.g., dev, staging, prod)
    owner        = var.owner      // Owner of the bucket
    cost-center  = "analytics"  // Cost center for billing purposes
    protected    = "true"       // Indicates the bucket is protected
  }
}

// Block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "tf_state_block" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls        = true  // Block public ACLs
  block_public_policy      = true  // Block public policies
  ignore_public_acls       = true  // Ignore public ACLs
  restrict_public_buckets  = true  // Restrict public bucket access
}

// Enable versioning for the S3 bucket to keep track of object versions
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled" // Enable versioning
  }
}

// --- Encryption (already had) ---
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_sse" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// --- Deny Delete Policy ---
data "aws_iam_policy_document" "deny_delete" {
  statement {
    sid    = "DenyDelete"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:DeleteBucket",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion"
    ]
    resources = [
      aws_s3_bucket.tf_state.arn,
      "${aws_s3_bucket.tf_state.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "tf_state_policy" {
  bucket = aws_s3_bucket.tf_state.id
  policy = data.aws_iam_policy_document.deny_delete.json
}

# --- DynamoDB Table for Locking ---
resource "aws_dynamodb_table" "tf_lock" {
  name         = "customer360-tf-lock-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

#   lifecycle {
#     prevent_destroy = true
#   }

  tags = {
    project      = "customer360"
    environment  = var.env
    owner        = var.owner
    cost-center  = "analytics"
    protected    = "true"
  }
}

output "state_bucket" {
  value = aws_s3_bucket.tf_state.bucket
}

output "lock_table" {
  value = aws_dynamodb_table.tf_lock.name
}
