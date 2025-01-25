terraform {
  backend "azurerm" {
  resource_group_name  = "terraformrg"
  storage_account_name = "terraformstoragedc5415e2"
  container_name       = "terraform"
  key                  = "aks.tfstate"
  }
}