module "web_app" {
  source = "./modules/web_app"
  name_prefix = "vrush"
  instance_type = "t2.micro"
  instance_count = 2
  vpc_id = "vpc-08a203e0fd63e9131"
  public_subnet = false
  key_name = "vrush"
  alb_listener_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:255945442255:listener/app/vrush-webapp-alb/15cbe23039d271af/cf08340adc67f430"
}

