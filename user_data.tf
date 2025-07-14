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
    bash <(curl -fsS https://packages.openvpn.net/as/install.sh) --as-version=2.14.3 --yes
    ovpn-init --ec2 --batch --force
    while [ ! -S /usr/local/openvpn_as/etc/sock/sagent ]; do
    sleep 1
    done
    admin_user=${var.admin_username}
    admin_pw=${var.admin_password}
    /usr/local/openvpn_as/scripts/sacli -k 'vpn.server.daemon.ovpndco' -v 'true' ConfigPut
    /usr/local/openvpn_as/scripts/sacli start
    exit 0
  EOF

  
  tags = {
    Name = "OpenVPNAccessServer_Terraform"
  }
}
