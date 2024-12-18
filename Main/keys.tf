# Key generation for ssh access to deployed virtual machines
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
resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.dev_key.public_key_openssh
}
output "private_key" {
  value     = tls_private_key.dev_key.private_key_pem
  sensitive = true
}
resource "local_file" "dev_key_ready" {
  filename = var.file_name
  content  = tls_private_key.dev_key.private_key_pem
}


# Key generation for S3 encryption
resource "aws_kms_key" "s3key" {
  description = "Key used for the server side encryption of the s3 bucket"
  deletion_window_in_days = 10
}