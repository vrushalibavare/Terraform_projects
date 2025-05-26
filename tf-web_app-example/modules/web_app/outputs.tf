output "target_group_arn" {
  value = aws_lb_target_group.web_app.arn
  
}
 output instance_public_ips {
  value = aws_instance.web_app[*].public_ip
}
