resource "tls_private_key" "priv_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ubuntuDT_key_pair" {
  key_name   = "key_pair"
  public_key = tls_private_key.priv_key.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${path.module}/key_pair.pem"
  content  = tls_private_key.priv_key.private_key_pem
}