variable "aws_profile" {
  type        = string
  default     = "c360"
  description = "AWS CLI profile"
}

variable "aws_region" {
  type        = string
  default     = "us-west-2"
}

variable "env" {
  type        = string
  default     = "dev"
}

// Define the project owner name
variable "owner" {
  description = "Project owner name"
  type        = string
  default     = "mish"
}
