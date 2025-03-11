data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_subnet" "private_endpoint" {
  count = var.private_endpoint != null ? 1 : 0

  name                  = var.private_endpoint.subnet_name
  virtual_network_name  = var.private_endpoint.virtual_network_name
  resource_group_name   = var.private_endpoint.virtual_network_resource_group_name
}

data "azurerm_key_vault" "encryption" {
  count = var.data_encryption != null ? 1 : 0

  name                = var.data_encryption.key_vault_name
  resource_group_name = var.data_encryption.key_vault_resource_group_name
}