output "id" {
  value = azurerm_application_gateway.application_gateway.id
}

output "name" {
  value = azurerm_application_gateway.application_gateway.name
}

output "resource_group_name" {
  value = azurerm_application_gateway.application_gateway.resource_group_name
}

output "location" {
  value = azurerm_application_gateway.application_gateway.location
}

output "sku_tier" {
  value = azurerm_application_gateway.application_gateway.sku[0].tier
}

output "public_ip_address" {
  value = azurerm_public_ip.application_gateway.ip_address
}

output "public_ip_fqdn" {
  value = azurerm_public_ip.application_gateway.fqdn
}
