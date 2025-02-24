terraform {
  source = "../.."
}

inputs = {
  local_virtual_network_name   = "vnet-weu-example-network-dev"
  local_resource_group_name    = "rg-weu-example-network-dev"
  remote_virtual_network_name  = "vnet-weu-example-network-stg"
  remote_resource_group_name   = "rg-weu-example-network-stg"
}

