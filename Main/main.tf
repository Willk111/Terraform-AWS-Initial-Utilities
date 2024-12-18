terraform { 
  required_providers {
    aws = { # Main providers for AWS deployment
      source  = "hashicorp/aws"
      version = "5.66.0"
    }

    local = { # Provider to allow local file creation (used for keys)
      source = "hashicorp/local"
      version = "2.5.2"
    }

    tls = { # Provider for tls key generation
      source = "hashicorp/tls"
      version = "4.0.6"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "annysahbucket" { # Basic S3 bucket, change the name as you wish
  bucket = "annysah-website-practice"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3encryption" { # Encryption resorce for server side encryption of the S3 bucket
  bucket = aws_s3_bucket.annysahbucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3key.arn
      sse_algorithm = "aws:kms"
    }
  }
}


#resource "aws_s3_account_public_access_block" "bucket_access_block" {
#  bucket = aws_s3_bucket.annysahbucket.id#
#
#  block_public_acls = false
#  block_public_policy = false
#  ignore_public_acls = false
#  restrict_public_buckets = false
#}

resource "aws_instance" "app_server" { # Basic Desktop running ubuntu
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



resource "aws_instance" "webserver" { # A server running ubuntu server
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

output "public_ip" { # Outputs the public ip to commandline after "terraform apply"
  value = aws_instance.webserver.public_ip
}