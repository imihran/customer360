variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "c360"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "env" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}
