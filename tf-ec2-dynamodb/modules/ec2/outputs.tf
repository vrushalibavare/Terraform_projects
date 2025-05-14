output "instance_publicip" {
  value = aws_instance.public.public_ip
}

output "instance_publicdns" {
  value = aws_instance.public.public_dns
}

output "instance_id" {
  value = aws_instance.public.id
}