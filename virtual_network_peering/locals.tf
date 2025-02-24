locals {

  local_virtual_network_name  = var.local_virtual_network_name
  local_resource_group_name   = var.local_resource_group_name
  remote_virtual_network_name = var.remote_virtual_network_name
  remote_resource_group_name  = var.remote_resource_group_name

  local_allow_virtual_network_access = var.local_allow_virtual_network_access
  local_allow_forwarded_traffic      = var.local_allow_forwarded_traffic
  local_allow_gateway_transit        = var.local_allow_gateway_transit
  local_use_remote_gateways          = var.local_use_remote_gateways
  local_peering_name = coalesce(
    var.local_peering_name,
    join("-", ["peering-to", var.remote_virtual_network_name])
  )

  remote_allow_virtual_network_access = var.remote_allow_virtual_network_access
  remote_allow_forwarded_traffic      = var.remote_allow_forwarded_traffic
  remote_allow_gateway_transit        = var.remote_allow_gateway_transit
  remote_use_remote_gateways          = var.remote_use_remote_gateways
  remote_peering_name = coalesce(
    var.remote_peering_name,
    join("-", ["peering-to", var.local_virtual_network_name])
  )

}