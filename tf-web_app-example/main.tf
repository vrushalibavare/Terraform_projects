module "web_app" {
  source = "./modules/web_app"
  name_prefix = "vrush"
  instance_type = "t2.micro"
  instance_count = 2
  vpc_id = "vpc-0b0b68bfad1955fc4"
  public_subnet = false
  key_name = "vrush"
  alb_listener_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:255945442255:listener/app/vrush-alb/7562156a51935853/2daec5a8e1b3e2e2"
}

