output "listener_url" {
  description = "URL for the web application listener with path"
  value       = module.web_app.listener_url
}

output "alb_listener_arn" {
  description = "ARN of the ALB listener"
  value       = module.web_app.alb_listener_arn
  
}
output "alb_arn" {
  description = "ARN of the ALB"
  value       = module.web_app.alb_arn
}

