
data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "vpn" {
  name             = local.resource_group_name
}
