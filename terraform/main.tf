// -----------------------------------------------------------------------------
// main.tf
// This file defines the root Terraform configuration for the project. It sets
// up the backend for state management, specifies the required providers, and
// configures the AWS provider for resource provisioning.
// -----------------------------------------------------------------------------

// Specify the required Terraform version and configure the backend for state management
terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "customer360-tfstate-dev" // S3 bucket for storing Terraform state
    key            = "terraform/state/root.tfstate" // Path to the state file in the bucket
    region         = "us-west-2" // AWS region for the S3 bucket
    dynamodb_table = "customer360-tf-lock-dev" // DynamoDB table for state locking
    encrypt        = true // Enable encryption for the state file
    profile        = "c360" // AWS CLI profile to use
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws" // Source of the AWS provider
      version = "~> 5.0" // Version constraint for the AWS provider
    }
  }
}

// Configure the AWS provider with the specified profile and region
provider "aws" {
  profile = "c360" // AWS CLI profile to use
  region  = "us-west-2" // AWS region for resource provisioning
}
