locals {
  selected_subnet_ids = var.public_subnet ? data.aws_subnets.public.ids : data.aws_subnets.private.ids
}

resource "aws_instance" "public" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  count = var.instance_count
  subnet_id = local.selected_subnet_ids[count.index % length(local.selected_subnet_ids)]
  associate_public_ip_address = var.public_subnet
  # Assigns a public IP address to the instance, if public_subnet is set to true.
  #key_name = var.key_name
  vpc_security_group_ids = [ aws_security_group.allow_ssh_http[count.index].id ]
  user_data = templatefile("${path.module}/scripts/install_httpd.sh",
  {
    file_content = "Terraform EC2-#${count.index + 1}"
  }
  )
  tags = {
    Name = "${var.name}-${count.index + 1}"
  }
}

resource "aws_security_group" "allow_ssh_http" {
  count = var.instance_count
  name = "${var.name}-${count.index + 1}-security-group"
  description = "allow ssh and http inbound"
  vpc_id = data.aws_vpc.selected.id
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

#resource "aws_key_pair" "keypair" {
 # key_name = var.key_name
  #public_key = file(var.public_key_path)
#}



