terraform {
  source = "../.."
}

inputs = {
  location     = "westeurope"
  resource_group_name = "rg-weu-example-network-dev"

  namespace    = "example"
  application  = "core"
  environment  = "development"
  resource_group_purpose = "vpn"

  # Optional inputs
  standardize_resource_group = false
  standardize_resources      = true
  include_environment        = true
}

