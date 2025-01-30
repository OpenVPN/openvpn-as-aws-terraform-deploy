# Provider configuration
provider "aws" {
  region = var.aws_region
  profile = "saml"
}

# Create a security group to allow SSH access
resource "aws_security_group" "AccessServerSecurityGroup" {
  name        = "AccessServerSecurityGroup"
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

# Fetch the AMI for the desired image
data "aws_ami" "ubuntu24_image" {
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"]  # Replace with the actual Marketplace image name
  }
}

# Create the EC2 instance with Ubuntu 24.04 LTS AMD64
resource "aws_instance" "OpenVPNAccessServer_Terraform" {
  ami               = data.aws_ami.ubuntu24_image.id
  instance_type     = var.aws_instance_type
  subnet_id         = var.subnet_id
  key_name          = var.key_name
  security_groups   = [aws_security_group.AccessServerSecurityGroup.id]

  # Metadata options
  metadata_options {
    http_tokens = "optional"   # Allow IMDSv1 and IMDSv2
    http_endpoint = "enabled"
  }
  
  user_data = <<-EOF
    #!/bin/bash
    bash <(curl -fsS https://packages.openvpn.net/as/install.sh | sed 's/PLIST\\x3d\"openvpn-as\"/PLIST\\x3d\"openvpn-as\\x3d2.14.2*\"/') --yes
    ovpn-init --ec2 --batch --force
    while [ ! -S /usr/local/openvpn_as/etc/sock/sagent ]; do
    sleep 1
    done
    admin_pw=${var.admin_password}
    admin_user=${var.admin_username}
    /usr/local/openvpn_as/scripts/sacli -k 'vpn.server.daemon.ovpndco' -v 'true' ConfigPut
    /usr/local/openvpn_as/scripts/sacli start
    exit 0
  EOF

  
  tags = {
    Name = "OpenVPNAccessServer_Terraform"
  }
}

# Outputs
output "openvpnas_admin_ui" {
  description = "OpenVPN Access Server Admin WebGUI URL"
  value       = "https://${aws_instance.OpenVPNAccessServer_Terraform.public_ip}:943/admin"
}

output "openvpnas_client_ui" {
  description = "OpenVPN Access Server Client WebGUI URL"
  value       = "https://${aws_instance.OpenVPNAccessServer_Terraform.public_ip}:943"
}

output "openvpnas_user" {
  description = "OpenVPN Access Server Admin User"
  value = {
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
}
