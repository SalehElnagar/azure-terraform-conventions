output "name" {
  value       = local.resource_name
  description = "VM Name"
}

output "name_context" {
  value       = local.name_context
  description = "Elements to construct the resource name"
}

output "location" {
  value       = local.mapped_location
  description = "The mapped enterprise location code corresponding to the original Azure location"
}

output "environment" {
  value       = local.environment
  description = "Environment"
}

output "environment_instance" {
  value       = local.environment_instance
  description = "Environment instance"
}

output "instance" {
  value       = local.instance
  description = "Instance"
}

output "tags" {
  value       = local.resource_tags
  description = "Normalized Tag map"
}

