variable "aws_region" {
  description = "AWS region to deploy the resources in"
  type        = string
  default     = "us-east-1"  # Replace with your desired AWS region
}

variable "aws_instance_type" {
  description = "AWS Instance type"
  type        = string
  default     = "t3.small"  # Replace with your desired AWS instance type
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy resources"
  type        = string
  default     = "vpc-d08f5daa"  # Replace with your actual VPC ID
}

variable "subnet_id" {
  description = "The ID of the Subnet to deploy resources"
  type        = string
  default     = "subnet-c4ac21ea"  # Replace with your actual Subnet ID
}

variable "key_name" {
  description = "The name of the SSH key to use for the instance"
  type        = string
  default     = "Brandon-SSH"  # Replace with your actual SSH Key uploaded to AWS Console
}

variable "admin_username" {
  description = "The OpenVPN Access Server admin username"
  type        = string
  default     = "terraform_admin"  # Replace with your desired OpenVPN admin username
}

variable "admin_password" {
  description = "The OpenVPN Access Server admin password"
  type        = string
  default     = "terraform_admin123"  # Replace with your desired OpenVPN admin password
}