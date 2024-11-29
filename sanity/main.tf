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

resource "aws_instance" "app_server" {
  ami                 = "ami-0182f373e66f89c85"
  instance_type       = "t2.nano"
  key_name            = aws_key_pair.my_key_pair.key_name
  subnet_id           = aws_subnet.new_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  associate_public_ip_address = true  # Ensure public IP 
}

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

resource "aws_instance" "webserver" {
  ami = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  availability_zone = "us-east-1e"
  
  key_name            = aws_key_pair.generated_key.key_name
  subnet_id           = aws_subnet.new_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  user_data = <<-EOF
              #!/bin/bash
              # Update and install dependencies
              sudo apt update -y
              sudo apt install -y python3 python3-pip

              # Create a directory for the WebSocket listener
              mkdir -p /home/ubuntu/bluesky_listener

              # Write the WebSocket listener script
              cat << 'PYTHON_SCRIPT' > /home/ubuntu/bluesky_listener/bluesky_listener.py
              import asyncio
              import websockets
              import boto3
              import json
              from datetime import datetime

              timestream_client = boto3.client("timestream-write", region_name="us-east-1")

              DATABASE_NAME = "basic"
              TABLE_NAME = "table"  # Replace with your Timestream table name

              async def listen():
                  uri = "wss://bsky.network/xrpc/com.atproto.sync.subscribeRepos"
                  try:
                      async with websockets.connect(uri) as websocket:
                          print("Connected to Bluesky firehose")
                          while True:
                              message = await websocket.recv()
                              print(f"Received message: {message}")
                              store_in_timestream(message)
                  except Exception as e:
                      print(f"Error: {e}")

              def store_in_timestream(message):
                  try:
                      current_time = str(int(datetime.now().timestamp() * 1000))  # Timestream expects timestamps in milliseconds
                      timestream_client.write_records(
                          DatabaseName=DATABASE_NAME,
                          TableName=TABLE_NAME,
                          Records=[
                              {
                                  "Dimensions": [
                                      {"Name": "Source", "Value": "Bluesky"},
                                  ],
                                  "MeasureName": "Message",
                                  "MeasureValue": json.dumps(message),
                                  "MeasureValueType": "VARCHAR",
                                  "Time": current_time,
                              }
                          ]
                      )
                      print("Data written to Timestream")
                  except Exception as e:
                      print(f"Failed to write to Timestream: {e}")

              if __name__ == "__main__":
                  asyncio.run(listen())
              PYTHON_SCRIPT

              # Install required Python packages
              pip3 install websockets boto3

              # Run the WebSocket listener in the background
              nohup python3 /home/ubuntu/bluesky_listener/bluesky_listener.py &

              EOF

  tags = {
    Name = "Webserver"
  }
}

resource "aws_timestreamwrite_database" "basic" {
  database_name = "basic"
}

resource "aws_timestreamwrite_table" "table" {
  database_name = aws_timestreamwrite_database.basic.database_name
  table_name = "table"
}

output "public_ip" {
  value = aws_instance.webserver.public_ip
}
