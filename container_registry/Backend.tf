terraform {
  backend "azurerm" {
  container_name       = "terraform"
  key                  = "acr.tfstate"
  }
}