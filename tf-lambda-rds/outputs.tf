output "database_subnet_ids" {
  description = "The IDs of the database subnets where RDS is launched"
  value       = data.aws_subnets.database.ids
}

output "rds_subnet_group_name" {
  description = "The name of the subnet group where RDS is launched"
  value       = data.aws_db_subnet_group.database.name
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = module.rds.db_instance_identifier
}