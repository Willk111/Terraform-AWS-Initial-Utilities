resource "aws_vpc" "new" { # Basic VPC for general use
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "new_subnet" { # Basic subnet for general use
  vpc_id                  = aws_vpc.new.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}




resource "aws_internet_gateway" "gw" { # Gateway connection for virtua machines to access the internet
  vpc_id = aws_vpc.new.id
  tags = {
    Name = "main"
  }
}


resource "aws_eip" "ip-test" {
  instance = aws_instance.app_server.id
}

resource "aws_route_table" "route-table-test-env" { # ROuting table to allow data through the internet gateway
  vpc_id = aws_vpc.new.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.new_subnet.id
  route_table_id = aws_route_table.route-table-test-env.id
}