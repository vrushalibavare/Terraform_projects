data aws_vpc selected {
  id = var.vpc_id
}

data aws_subnets public {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name = "tag:Name"

    values = ["*public*"]
  }
}

data aws_subnets private {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name = "tag:Name"

    values = ["*private*"]
  }
}

data aws_ami "latest_amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}



# Get the ALB listener details using the provided ARN
data "aws_lb_listener" "selected" {
  arn = var.alb_listener_arn
}

# Get the load balancer details from the listener
data "aws_lb" "from_listener" {
  arn = data.aws_lb_listener.selected.load_balancer_arn
}


