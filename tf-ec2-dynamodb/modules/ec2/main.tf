resource "aws_instance" "public" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  subnet_id = data.aws_subnet.selected.id
  associate_public_ip_address = true
  key_name = var.key_name
  iam_instance_profile = var.iam_instance_profile
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "${var.name}-ec2"
  }
}

resource "aws_security_group" "allow_ssh" {
  name = "${var.name}-security-group"
  description = "allow ssh inbound"
  vpc_id = data.aws_vpc.selected.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ip4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}