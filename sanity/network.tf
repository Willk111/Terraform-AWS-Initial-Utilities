resource "aws_vpc" "new" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "new_subnet" {
  vpc_id                  = aws_vpc.new.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true  
}

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



resource "aws_eip" "ip-test" {
  instance = aws_instance.app_server.id
}

resource "aws_route_table" "route-table-test-env" {
  vpc_id = "${aws_vpc.new.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.new_subnet.id}"
  route_table_id = "${aws_route_table.route-table-test-env.id}"
}