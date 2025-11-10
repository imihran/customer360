// -----------------------------------------------------------------------------
// variables.tf
// This file defines input variables for the Terraform configuration, providing
// default values and descriptions for AWS settings, deployment environments,
// and project-specific metadata. These variables ensure consistent and reusable
// infrastructure definitions across different environments.
// -----------------------------------------------------------------------------

// Define the AWS CLI profile to use for authentication and configuration
variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "c360"
}

// Specify the AWS region where resources will be deployed
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

// Define the deployment environment (e.g., dev, staging, prod)
variable "env" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}

// Define the project owner name
variable "owner" {
  description = "Project owner name"
  type        = string
  default     = "mish"
}

