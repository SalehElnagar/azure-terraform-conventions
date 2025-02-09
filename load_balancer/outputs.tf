output "id" {
  value = azurerm_lb.lb.id
}

output "name" {
  value = azurerm_lb.lb.name
}

output "private_ip_address" {
  value = azurerm_lb.lb.private_ip_address
}

output "private_ip_addresses" {
  value = azurerm_lb.lb.private_ip_addresses
}

output "backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.lb.id
}

