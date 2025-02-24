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

output "backend_address_pool_ids" {
  value = [for i in azurerm_lb_backend_address_pool.lb: i.id]
}

// output "frontend_ip_configuration" {
//   value = azurerm_lb.lb.frontend_ip_configuration
// }

output "frontend_ip_configurations" {
  value = [for f in azurerm_lb.lb.frontend_ip_configuration: {
    id                  = f.id
    name                = f.name
    private_ip_address  = f.private_ip_address 
  }]
}
