output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.public.id
}

output "instance_az" {
  description = "Availability Zone of the EC2 instance"
  value       = aws_instance.public.availability_zone
}