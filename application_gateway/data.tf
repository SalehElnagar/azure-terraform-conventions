data "azurerm_resource_group" "application_gateway" {
  name = var.resource_group_name
}

data "azurerm_subnet" "application_gateway" {
  name                 = var.virtual_network_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group_name
}