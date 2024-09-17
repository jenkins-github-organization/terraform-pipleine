terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-05134c8ef96964280"
  instance_type = "t3.micro"
  monitoring    = true

  tags = {
    Name = "MyEC2Instance"
  }

  key_name = "aswin-key"
  vpc_security_group_ids = ["sg-0fe4363da3994c100"]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "example_instance_id" {
  value = aws_instance.example.id
}

output "security_group_id" {
  value = aws_security_group.allow_ssh.id
}
