
output "alb_url" {
  description = "URL for the Application Load Balancer"
  value       = "http://${data.aws_lb.from_listener.dns_name}"
}

output "listener_url" {
  description = "URL for the web application listener with path"
  value       = "http://${data.aws_lb.from_listener.dns_name}/vrush"
}

output "instance_public_ips" {
  description = "Public IP addresses of the web app instances"
  value       = aws_instance.web_app[*].public_ip
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.web_app.arn
}
 output "alb_listener_arn" {
  description = "ARN of the ALB listener"
  value       = data.aws_lb_listener.selected.arn
   
 }

 output "alb_arn" {
  description = "ARN of the ALB"
  value       = data.aws_lb.from_listener.arn
 }