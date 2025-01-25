output "id" {
  value       = azurerm_container_registry.container.id
  description = "The Container Registry ID."
}

output "login_service" {
  value       = azurerm_container_registry.container.id
  description = "The URL that can be used to log into the container registry."
}

output "admin_username" {
  value       = azurerm_container_registry.container.admin_username
  description = "The Username associated with the Container Registry Admin account."
}

output "admin_password" {
  value       = azurerm_container_registry.container.admin_password
  description = "The Password associated with the Container Registry Admin account."
  sensitive   = true
}
