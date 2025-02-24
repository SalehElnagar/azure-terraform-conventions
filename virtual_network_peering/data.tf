data "azurerm_virtual_network" "local" {
  name                = var.local_virtual_network_name
  resource_group_name = var.local_resource_group_name
  provider            = azurerm.dev
}

data "azurerm_virtual_network" "remote" {
  name                = var.remote_virtual_network_name
  resource_group_name = var.remote_resource_group_name
  provider            = azurerm.stg
}
