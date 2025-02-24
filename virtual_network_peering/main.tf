resource "azurerm_virtual_network_peering" "local" {
  name                         = local.local_peering_name
  resource_group_name          = data.azurerm_virtual_network.local.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.local.name
  remote_virtual_network_id    = data.azurerm_virtual_network.remote.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  provider                     = azurerm.dev
}

resource "azurerm_virtual_network_peering" "remote" {
  name                         = local.remote_peering_name
  resource_group_name          = data.azurerm_virtual_network.remote.resource_group_name
  virtual_network_name         = data.azurerm_virtual_network.remote.name
  remote_virtual_network_id    = data.azurerm_virtual_network.local.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  provider                     = azurerm.stg
}