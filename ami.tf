# Fetch the AMI for the desired image
data "aws_ami" "ubuntu26_image" {
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server*"]  # Replace with the actual image name
  }
}