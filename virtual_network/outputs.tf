output "id" {
  value       = module.virtual_network.id
  description = "The virtual network Id."
}

output "name" {
  value       = module.virtual_network.name
  description = "The virtual network name."
}

output "resource_group_name" {
  value       = azurerm_resource_group.network.name
  description = "The virtual network resource group name."
}
output "resource_group_id" {
  value       = azurerm_resource_group.network.id
  description = "The virtual network resource group id."
}

output "address_space" {
  value       = element(module.virtual_network.address_space, 0)
  description = "The address space for the virtual network."
}

// output "route_tables" {
//   value       = [for s in azurerm_route_table.network : s]
//   description = "List of Route Tables created."
// }

output "subnets" {
  value = {
    for s in module.virtual_network.subnets :
    s.name => {
      id             = s.id
      name           = s.name
      address_prefix = s.address_prefix
    }
  }

  description = "List of subnets for the virtual network."
}