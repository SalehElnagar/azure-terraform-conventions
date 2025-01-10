
output "environment_instance" {
  value       = var.environment_instance
  description = "Number indicating instance of environment"
}

output "network_security_group_name" {
  value       = local.network_security_group_name
  description = "The name of the network security group"
}

output "subnet_name" {
  value       = local.subnet_name
  description = "The name of the subnet"
}

output "route_table_name" {
  value       = local.route_table_name
  description = "The name of the route table"
}

output "resource_names" {
  value       = local.resource_names
  description = "A map of the networking resource names by type"
}

output "tags" {
  value       = local.tags
  description = "Normalized Tag map"
}

