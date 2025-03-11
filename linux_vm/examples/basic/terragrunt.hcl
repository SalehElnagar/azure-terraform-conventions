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
  virtual_machine_user_name = "devops"
  virtual_machine_ssh_key_data = ["ssh-rsa AAAAB3NzaC1..."]
  source_image_publisher = "Canonical"
  source_image_offer     = "0001-com-ubuntu-server-jammy"
  source_image_sku       = "22_04-lts"
  source_image_version   = "latest"
}

