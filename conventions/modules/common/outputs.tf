output "locations" {
  value       = local.azure_location_map
  description = "Azure to enterprise location map"
}

output "environments" {
  value       = local.environment_map
  description = "Environments for most resources"
}

output "short_environments" {
  value       = local.short_environment_map
  description = "Shortened environments for most resources"
}

output "vm_environments" {
  value       = local.vm_environment_map
  description = "Shortened environments for virtual machines"
}

output "base_tags" {
  value       = local.tag_map
  description = "Base Tags for all resources"
}

