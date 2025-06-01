output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.public[*].id
}

output "instance_az" {
  description = "Availability Zone of the EC2 instance"
  value       = aws_instance.public[*].availability_zone
}

output "instance_publicip" {
  value = aws_instance.public[*].public_ip
}

output "instance_publicdns" {
  value = aws_instance.public[*].public_dns
}
