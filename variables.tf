variable "aws_region" {
  description = "AWS region to deploy the resources in"
  type        = string
  default     = "us-east-1"  # Replace with your desired AWS region
}

variable "aws_instance_type" {
  description = "Access Server EC2 instance type"
  type        = string
  default     = "t3.small"  # Replace with your desired AWS instance type
}

variable "vpc_id" {
  description = "ID of your existing Virtual Private Cloud (VPC)"
  type        = string
  default     = "vpc-d08f5daa"  # Replace with your actual VPC ID
}

variable "subnet_id" {
  description = "ID of your existing Subnet"
  type        = string
  default     = "subnet-c4ac21ea"  # Replace with your actual Subnet ID
}

variable "key_name" {
  description = "Name of an existing EC2 KeyPair to enable SSH access to the instance"
  type        = string
  default     = "OpenVPNAS-SSH"  # Replace with your actual SSH Key uploaded to AWS Console
}

variable "admin_username" {
  description = "The OpenVPN Access Server admin username"
  type        = string
  default     = "admin1"  # Replace with your desired OpenVPN admin username
}

variable "admin_password" {
  description = "The OpenVPN Access Server admin password"
  type        = string
  default     = "p@$w0rd"  # Replace with your desired OpenVPN admin password
}

variable "enable_lets_encrypt" {
  description = "Whether to automatically request and install a Let's Encrypt TLS certificate for the Access Server once it boots"
  type        = bool
  default     = true
}

variable "use_static_public_ip" {
  description = "Whether to allocate a static Elastic IP (recommended) for the Access Server instead of relying on AWS's dynamic auto-assigned public IP, which can change across stop/start cycles"
  type        = bool
  default     = true
}
