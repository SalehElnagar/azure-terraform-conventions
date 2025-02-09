terraform {
  backend "azurerm" {
  container_name       = "terraform"
  key                  = "agic.tfstate"
  }
}