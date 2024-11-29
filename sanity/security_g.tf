resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  vpc_id      = aws_vpc.new.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change to a specific IP range if security is a concern
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_policy" "timestream_write_policy" {
  name = "TimestreamWritePolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "timestream:WriteRecords"
        ],
        Resource = "arn:aws:timestream:us-east-1:*:database/${aws_timestreamwrite_database.basic.database_name}"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_timestream_role.name
}

resource "aws_iam_role" "ec2_timestream_role" {
  name = "ec2-timestream-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_timestream_role.name
  policy_arn = aws_iam_policy.timestream_write_policy.arn
}

resource "aws_security_group" "instance_sg" {
  name = "webserver_sg"
  description = "Allows inbound SSH and HTTP traffic"
  vpc_id = aws_vpc.new.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Web-traffic"
  }
}



resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.dev_key.public_key_openssh
}

locals {
  priv_keys = tolist(tls_private_key.dev_key[*].private_key_pem)
}

output "private_key" {
  value     = tls_private_key.dev_key.private_key_pem
  sensitive = true
}

resource "local_file" "dev_key_ready" {
  filename = var.file_name
  content = tls_private_key.dev_key.private_key_pem
}