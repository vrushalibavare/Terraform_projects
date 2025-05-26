locals {
  name_prefix     = "vrush"
  instance_type   = "t2.micro"
  instance_count  = 2
  key_name        = "vrush"
  alb_name        = "${local.name_prefix}-webapp-alb"
}
  

module "web_app" {
  source         = "./modules/web_app"
  name_prefix    = local.name_prefix
  instance_type  = local.instance_type
  instance_count = local.instance_count
  vpc_id         = data.aws_vpc.selected.id
  key_name       = local.key_name
  
}

module "alb" {
  source                     = "terraform-aws-modules/alb/aws"
  name                       = local.alb_name
  vpc_id                     = data.aws_vpc.selected.id
  subnets                    = data.aws_subnets.public.ids
  enable_deletion_protection = false
  

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}

resource "aws_lb_listener" "web_app" {
  load_balancer_arn = module.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = module.web_app.target_group_arn
  }
}

resource "aws_lb_listener_rule" "web_app" {
  listener_arn = aws_lb_listener.web_app.arn
  priority     = 10
  action {
    type = "forward"
    target_group_arn = module.web_app.target_group_arn
  }
  condition {
    path_pattern {
      values = ["/vrush", "/vrush/*"]
    }
  }    
}
