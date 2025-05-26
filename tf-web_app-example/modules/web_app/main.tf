locals {
  selected_subnet_ids = var.public_subnet ? data.aws_subnets.public.ids : data.aws_subnets.private.ids
}
#If var.public_subnet is true, it uses data.aws_subnets.public.ids

#If var.public_subnet is false, it uses data.aws_subnets.private.ids

resource "aws_instance" "web_app" {
  count         = var.instance_count
  ami           = data.aws_ami.latest_amazon_linux.id # Example AMI ID, replace with a valid one
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id     = local.selected_subnet_ids[count.index % length(local.selected_subnet_ids)]
  #This line implements a round-robin distribution pattern for EC2 instances across available subnets

  vpc_security_group_ids      = [aws_security_group.webapp.id]
  user_data = templatefile("${path.module}/init-script.sh", 
  {
    file_content = "WebApp-#${count.index + 1}"
    
  })

  # Only assign public IPs to instances in public subnets
  associate_public_ip_address = var.public_subnet
 
  tags = {
    Name = "${var.name_prefix}-webapp-${count.index + 1}"
  }
}

resource "aws_security_group" "webapp" {
  name        = "${var.name_prefix}-webapp"
  description = "Security group for web app instances"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
    ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH traffic"
      ipv6_cidr_blocks = ["::/0"]
    }
    


    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "web_app" {
  name = "${var.name_prefix}-webapp-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.selected.id
  health_check {
    port = 80
    protocol = "HTTP"
    interval = 30
    timeout = 5
    }
}

resource "aws_lb_target_group_attachment" "web_app" {
  count = var.instance_count
  target_group_arn = aws_lb_target_group.web_app.arn
  target_id = aws_instance.web_app[count.index].id
  port = 80
}



