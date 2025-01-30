# Provider configuration
provider "aws" {
  region = var.aws_region
  profile = "saml"
}

# Create a security group to allow SSH access
resource "aws_security_group" "OpenVPN-Access-Server_SecurityGroup" {
  name        = "OpenVPN-Access-Server_SecurityGroup"
  description = "Enable needed access to Access Server"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 945
    to_port     = 945
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Fetch the AMI for the desired Marketplace image
data "aws_ami" "marketplace_image" {
  most_recent = true
  owners      = ["679593333241"]
  
  filter {
    name   = "name"
    values = ["OpenVPN Access Server Community Image-fe8020db-5343-4c43-9e65-5ed4a825c931"]  # Replace with the actual Marketplace image name
  }
}

# Create the EC2 instance from the Marketplace image
resource "aws_instance" "OpenVPN-Access-Server_Terraform" {
  ami               = data.aws_ami.marketplace_image.id
  instance_type     = var.aws_instance_type
  subnet_id         = var.subnet_id
  key_name          = var.key_name
  security_groups   = [aws_security_group.OpenVPN-Access-Server_SecurityGroup.id]

  # Metadata options
  metadata_options {
    http_tokens = "optional"   # Allow IMDSv1 and IMDSv2
    http_endpoint = "enabled"
  }
  
  user_data = <<-EOF
    #!/bin/bash
    admin_pw=${var.admin_password}
    admin_user=${var.admin_username}
  EOF
  
  tags = {
    Name = "OpenVPN-Access-Server_Terraform"
  }
}

# Outputs
output "openvpnas_admin_ui" {
  description = "OpenVPN Access Server Admin WebGUI URL"
  value       = "https://${aws_instance.OpenVPN-Access-Server_Terraform.public_ip}:943/admin"
}

output "openvpnas_client_ui" {
  description = "OpenVPN Access Server Client WebGUI URL"
  value       = "https://${aws_instance.OpenVPN-Access-Server_Terraform.public_ip}:943"
}

output "openvpnas_user" {
  description = "OpenVPN Access Server Admin User"
  value = {
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
}