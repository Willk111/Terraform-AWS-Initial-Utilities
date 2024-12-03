terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }

    local = {
      source = "hashicorp/local"
      version = "2.5.2"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.0.6"
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

resource "aws_instance" "app_server" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ubuntuDT_key_pair.key_name
  subnet_id              = aws_subnet.new_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  associate_public_ip_address = true # Ensure public IP 

  tags = {
    Name = "Desktop"
  }
}



resource "aws_instance" "webserver" {
  ami               = "ami-0866a3c8686eaeeba"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1c"



  key_name               = aws_key_pair.ubuntuDT_key_pair.key_name
  subnet_id              = aws_subnet.new_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Webserver"
  }
}

output "public_ip" {
  value = aws_instance.webserver.public_ip
}