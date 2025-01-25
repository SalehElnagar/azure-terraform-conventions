terraform {
  source = "../.."
}

inputs = {
  location     = "westeurope"
  storageName  = "tfstateweu"
  key          = "vnet/terraform.tfstate"

  namespace    = "example"
  application  = "core"
  environment  = "development"
  resource_group_purpose = "vnet"

  # Optional inputs
  virtual_network_address_space = ["10.40.0.0/22", "10.50.0.0/19"]
  region_address_space          = "10.0.0.0/8"
  standardize_resource_group    = false
  standardize_resources         = true
  include_environment           = true
}

