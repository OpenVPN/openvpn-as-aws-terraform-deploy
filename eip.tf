# Static Elastic IP for the Access Server
resource "aws_eip" "AccessServerEIP" {
  count  = var.use_static_public_ip ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "AccessServerEIP"
  }
}

# Associates the EIP with the instance after both exist.
resource "aws_eip_association" "AccessServerEIPAssociation" {
  count         = var.use_static_public_ip ? 1 : 0
  instance_id   = aws_instance.OpenVPNAccessServer_Terraform.id
  allocation_id = aws_eip.AccessServerEIP[0].id
}
