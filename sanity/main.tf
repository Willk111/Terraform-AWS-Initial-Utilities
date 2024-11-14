terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "annysahbucket" {
  bucket = "annysah-website-practice"
}

#resource "aws_s3_account_public_access_block" "bucket_access_block" {
#  bucket = aws_s3_bucket.annysahbucket.id#
#
#  block_public_acls = false
#  block_public_policy = false
#  ignore_public_acls = false
#  restrict_public_buckets = false
#}


resource "tls_private_key" "priv_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "key_pair"
  public_key = tls_private_key.priv_key.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${path.module}/key_pair.pem"
  content  = tls_private_key.priv_key.private_key_pem
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.new.id
  tags = {
    Name = "main"
  }
}



resource "aws_instance" "app_server" {
  ami                 = "ami-0182f373e66f89c85"
  instance_type       = "t2.nano"
  key_name            = aws_key_pair.my_key_pair.key_name
  subnet_id           = aws_subnet.new_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  associate_public_ip_address = true  # Ensure public IP 
}