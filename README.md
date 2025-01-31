
# OpenVPN Access Server Deployment on AWS Cloud Using Terraform

This Terraform project automates the deployment of an **OpenVPN Access Server**. The OpenVPN Access Server is installed on a generic Linux instance using a custom script executed via **cloud-init** during the provisioning process.

## Prerequisites

- AWS Cloud account with permissions to manage VPC, Subnet, and instances.
- An **AWS CLI API Keys**.
- SSH key created and uploaded to AWS Cloud Account.

## Input Variables

The key variables include:

- `aws_region`: The region where resources will be deployed (`us-east-1`).
- `aws_instance_type`: EC2 instance type (`t3-small`).
- `vpc_id`: ID of your existing Virtual Private Cloud (VPC).
- `subnet_id`: ID of your existing Subnet.
- `key_name`: SSH key to access the instance.
- `admin_username`: The OpenVPN Access Server admin username.
- `admin_password`: The OpenVPN Access Server admin password.

## Project Structure

```bash
├── README.md               # Project documentation
├── ami.tf                  # Base image configuration
├── outputs.tf              # Outputs from Admin credentials, Admin UI, and Client UI URLs
├── provider.tf             # Provider info
├── security_groups.tf      # VPC and Security Group setup
├── user_data.tf            # Subnet and User Data setup
├── variables.tf            # Input variables
```
