output "id" {
  value = azurerm_firewall.firewall.id
}

output "name" {
  value = azurerm_firewall.firewall.name
}

output "resource_group_name" {
  value = azurerm_firewall.firewall.resource_group_name
}

output "private_ip_address" {
  value = element([for ip in azurerm_firewall.firewall.ip_configuration : ip.private_ip_address if ip.private_ip_address != null], 0)
}

output "public_ip_address" {
  value = azurerm_public_ip.firewall.ip_address
}