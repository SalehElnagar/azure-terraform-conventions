output "name" {
  value       = local.resource_group_name
  description = "Normalized name"
}

output "name_context" {
  value       = local.name_context
  description = "Elements to construct the resource name"
}

output "location" {
  value       = local.mapped_location
  description = "The mapped enterprise location code corresponding to the original Azure location"

  precondition {
    condition     = local.mapped_location != null
    error_message = format("Location '%s' is not supported. Provide an overrides.locations entry or use a supported Azure region name.", local.location)
  }
}

output "namespace" {
  value       = local.namespace
  description = "Normalized namespace"
}

output "purpose" {
  value       = local.purpose
  description = "Normalized purpose"
}

output "attributes" {
  value       = local.attributes
  description = "List of attributes"
}

output "environment" {
  value       = local.environment
  description = "Original environment"

  precondition {
    condition     = local.mapped_environment != null
    error_message = format("Environment '%s' is not supported. Provide an overrides.environments entry or use a supported environment name.", local.environment)
  }
}

output "environment_instance" {
  value       = local.environment_instance
  description = "Environment instance"
}

output "generated_tags" {
  value       = local.generated_tags
  description = "Tags that were generated as part of the resource name"
}

output "tags" {
  value       = local.resource_tags
  description = "Normalized Tag map"
}