data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "network" {
  name = local.virtual_network_resource_group_name
}

data "azurerm_subnet" "network" {
  name                 = local.virtual_network_subnet_name
  virtual_network_name = local.virtual_network_name
  resource_group_name  = local.virtual_network_resource_group_name
}

data "azurerm_role_definition" "vmss" {
  for_each = toset(local.system_identity_role_assignments)

  name  = each.key
  scope = data.azurerm_subscription.current.id
}