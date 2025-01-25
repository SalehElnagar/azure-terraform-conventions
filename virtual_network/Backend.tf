terraform {
  backend "azurerm" {
  container_name       = "terraform"
  key                  = "virtual_network.tfstate"
  }
}