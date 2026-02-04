# --- Data Sources ---

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_ami" "ubuntu_ohio" {
  provider    = aws.ohio
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# --- Resources ---

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t3.small"
  
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_web.id]
  associate_public_ip_address = true 
  key_name                    = aws_key_pair.deployer.key_name

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    encrypted   = true
    tags = {
      Name = "root-volume-123"
    }
  }

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  user_data = <<-EOF
             #!/bin/bash
    
    # 1. Update and Install Dependencies
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y git build-essential

    # 2. Install Node.js 20 (LTS) 
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs

    # 3. Install PM2 (Process Manager) globally
    npm install pm2 -g

    # 4. Switch to 'ubuntu' user to create the project 
    # (We don't want to own files as root)
    su - ubuntu -c '
      cd /home/ubuntu
      
      # Create Strapi project with SQLite (Quickstart)
      # --no-run: Don't start it yet, we want to use PM2
      npx create-strapi-app@latest my-strapi-project --quickstart --no-run

      # Build the Admin UI
      cd my-strapi-project
      npm run build

      # Start Strapi with PM2 in the background
      pm2 start npm --name "strapi" -- run start
      
      # Save PM2 list so it restarts on reboot
      pm2 save
    '
              EOF

  tags = {
    Name    = "Intern-Task-Web-Server-1"
    Project = "Terraform-Demo"
  }

  lifecycle {
    ignore_changes = [ ami ]
  }
}

resource "aws_instance" "instance-2" {
  provider      = aws.ohio
  ami           = data.aws_ami.ubuntu_ohio.id
  instance_type = "t2.micro"

  tags = {
    name = "Inter-task-web-server-2-ohio"
  }
  
  lifecycle {
    ignore_changes = [ ami ]
  }
}