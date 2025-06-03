output "private_route_table_ids_vpc1" {
  value = module.vpc1.private_route_table_ids
  
}

output "public_route_table_ids_vpc1" {
  value = module.vpc1.public_route_table_ids
  
}
output "private_route_table_ids_vpc2" {
  value = module.vpc2.private_route_table_ids
  
} 
output "public_route_table_ids_vpc2" {
  value = module.vpc2.public_route_table_ids
  
} 
