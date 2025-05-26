output "listener_url" {
  description = "URL for the web application listener with path"
  value       = "http://${module.alb.dns_name}"
}

output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.dns_name
}

output "vrush_app_url" {
  description = "URL for the web application with the vrush path"
  value       = "http://${module.alb.dns_name}/vrush"
}



