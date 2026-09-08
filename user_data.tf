# Create the EC2 instance with Ubuntu 24.04 LTS AMD64
resource "aws_instance" "OpenVPNAccessServer_Terraform" {
  ami                         = data.aws_ami.ubuntu24_image.id
  instance_type               = var.aws_instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  security_groups             = [aws_security_group.AccessServerSecurityGroup.id]
  associate_public_ip_address = var.use_static_public_ip ? false : true

  # Metadata options
  metadata_options {
    http_tokens = "optional"   # Allow IMDSv1 and IMDSv2
    http_endpoint = "enabled"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
    dpkg-reconfigure -f noninteractive unattended-upgrades
    OVPN_INIT_MANUAL=true bash <(curl -fsS https://packages.openvpn.net/as/install.sh) --as-version=3.2.2 --yes
    ovpn-init --ec2 --batch --force
    apt-mark hold openvpn-as
    . /usr/local/openvpn_as/etc/VERSION
    echo "OpenVPN Access Server Appliance $AS_VERSION \n \l" > /etc/issue
    cat > /etc/update-motd.d/00-header <<HEADER
    #!/bin/sh
    echo "Welcome to OpenVPN Access Server Appliance $AS_VERSION"
    HEADER
    %{if var.enable_lets_encrypt}
    TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    %{if var.use_static_public_ip}
    EXPECTED_IP=${aws_eip.AccessServerEIP[0].public_ip}
    until [ "$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)" = "$EXPECTED_IP" ]; do
      sleep 2
      TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    done
    PUBLIC_IP=$EXPECTED_IP
    %{else}
    PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)
    %{endif}
    until sacli status 2>/dev/null | grep -q '"api": "on"'; do sleep 2; done
    sacli --key "acme.ip_addresses.0" --value "$PUBLIC_IP" ConfigPut
    sacli --key "acme.cert_profile" --value "shortlived" ConfigPut
    sacli start
    echo y | sacli AcmeRegisterAccount
    sacli AcmeRequestCertificate
    %{endif}
    exit 0
    admin_user=${var.admin_username}
    admin_pw=${var.admin_password}
    reroute_gw=1
    reroute_dns=1
  EOF

  tags = {
    Name = "OpenVPNAccessServer_Terraform"
  }
}
