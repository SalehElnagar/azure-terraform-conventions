output "local_peering_id" {
  value       = azurerm_virtual_network_peering.local.id
  description = "Local peering Id"
}

output "remote_peering_id" {
  value       = azurerm_virtual_network_peering.remote.id
  description = "Remote peering Id"
}