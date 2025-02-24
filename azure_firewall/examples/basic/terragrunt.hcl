terraform {
  source = "../.."
}

inputs = {
  resource_group_name = "rg-weu-example-network-dev"
  subnet_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-weu-example-network-dev/providers/Microsoft.Network/virtualNetworks/vnet-weu-example-network-dev/subnets/AzureFirewallSubnet"

  namespace    = "example"
  application  = "network"
  environment  = "development"
  purpose      = "afw"
}

