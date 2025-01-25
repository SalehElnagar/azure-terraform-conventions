locals {
  location                    = var.location
  vpn_gateway_name            = var.vpn_gateway_name
  resource_group_name         = var.resource_group_name
  subnet_id                   = var.subnet_id
  public_ip                   = var.public_ip
  local_network_gateway_name  = var.local_network_gateway_name
  virtual_network_gateway_connection_name = var.virtual_network_gateway_connection_name
}
