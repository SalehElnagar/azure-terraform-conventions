terraform {
  source = "../.."
}

inputs = {
  resource_group_name                 = "rg-weu-example-compute-dev"
  location                            = "westeurope"
  virtual_network_resource_group_name = "rg-weu-example-network-dev"
  virtual_network_name                = "vnet-weu-example-network-dev"
  virtual_network_subnet_name         = "default"

  namespace    = "example"
  application  = "compute"
  environment  = "development"

  virtual_machine_purpose   = "app"
  virtual_machine_user_name = "Administrator"
  virtual_machine_password  = "SuperSecretPassword123!"
}

