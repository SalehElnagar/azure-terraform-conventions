data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    storage_account_name = var.storageName
    container_name       = "terraform"
    access_key           =  var.key
    key                  = "virtual_network.tfstate"
  }
}

data "azurerm_virtual_network" "aks" {
  name                  = data.terraform_remote_state.vnet.outputs.name
  resource_group_name   = data.terraform_remote_state.vnet.outputs.resource_group_name
}

data "azurerm_subnet" "aks" {
  for_each = toset(data.azurerm_virtual_network.aks.subnets)

  name                  = each.value
  virtual_network_name  = data.azurerm_virtual_network.aks.name
  resource_group_name   = data.azurerm_virtual_network.aks.resource_group_name
}

data "azuread_groups" "aks_admin" {
  display_names = local.aad_admin_group_names
}

data "azuread_groups" "aks_user" {
  display_names = local.aad_user_group_names
}

data "terraform_remote_state" "acr" {
  backend = "azurerm"
  config = {
    storage_account_name = var.storageName
    container_name       = "terraform"
    key                  = "acr.tfstate"
    access_key = var.key
  }
}
