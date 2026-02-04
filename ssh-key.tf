# 1. Create the Key Pair in Terraform memory
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Upload the Public Key to AWS
resource "aws_key_pair" "deployer" {
  key_name   = "my-instance-strapi-key" # Name seen in AWS Console
  public_key = tls_private_key.my_key.public_key_openssh
}

resource "local_file" "private_key" {
  content = tls_private_key.my_key.private_key_pem

  # 1. Use Forward Slashes (/)
  # 2. Add the actual filename (e.g., my-key.pem) at the end
  filename = "C:/Users/Test Machine/Downloads/key-aws-ssh/saksham-key.pem"
}