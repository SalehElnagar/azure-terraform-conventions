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

data "azurerm_virtual_network" "application_gateway_ingress" {
  name                  = data.terraform_remote_state.vnet.outputs.name
  resource_group_name   = data.terraform_remote_state.vnet.outputs.resource_group_name
}

data "azurerm_subnet" "application_gateway_ingress" {
  for_each = toset(data.azurerm_virtual_network.application_gateway_ingress.subnets)

  name                  = each.value
  virtual_network_name  = data.azurerm_virtual_network.application_gateway_ingress.name
  resource_group_name   = data.azurerm_virtual_network.application_gateway_ingress.resource_group_name
}

data "terraform_remote_state" "aks" {
  backend = "azurerm"
  config = {
    storage_account_name = var.storageName
    container_name       = "terraform"
    access_key           =  var.key
    key                  = "aks.tfstate"
  }
}
