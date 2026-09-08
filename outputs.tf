# Outputs
locals {
  access_server_public_ip = var.use_static_public_ip ? aws_eip.AccessServerEIP[0].public_ip : aws_instance.OpenVPNAccessServer_Terraform.public_ip
}

output "admin_ui_url" {
  description = "OpenVPN Access Server Admin Web UI URL"
  value       = "https://${local.access_server_public_ip}:943/admin"
}

output "client_ui_url" {
  description = "OpenVPN Access Server Client Web UI URL"
  value       = "https://${local.access_server_public_ip}:943"
}

output "openvpnas_user" {
  description = "OpenVPN Access Server Admin Credentials"
  value = {
    admin_account  = var.admin_username
    admin_password = var.admin_password
  }
}
