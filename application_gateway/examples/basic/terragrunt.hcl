terraform {
  source = "../.."
}

inputs = {
  location            = "westeurope"
  resource_group_name = "rg-weu-example-network-dev"

  namespace    = "example"
  application  = "network"
  environment  = "development"
  purpose      = "appgw"
  attributes   = []
}

