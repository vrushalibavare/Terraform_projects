resource "aws_instance" "public" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  subnet_id = data.aws_subnet.selected.id
  associate_public_ip_address = true
  key_name = var.key_name
  iam_instance_profile = var.iam_instance_profile
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  
  # Enable IMDSv2
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"  # This enforces IMDSv2
    http_put_response_hop_limit = 2  # Increased to allow metadata access
  }
  
  tags = {
    Name = "${var.name}-ec2"
  }
}


resource "aws_security_group" "allow_ssh" {
  name = "${var.name}-security-group"
  description = "allow ssh, http, and https inbound"
  vpc_id = data.aws_vpc.selected.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ip4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}

# Add egress rule to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"  # All protocols
}