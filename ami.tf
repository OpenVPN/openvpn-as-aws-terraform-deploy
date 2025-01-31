# Fetch the AMI for the desired image
data "aws_ami" "ubuntu24_image" {
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"]  # Replace with the actual image name
  }
}