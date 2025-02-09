terraform {
  backend "azurerm" {
  container_name       = "terraform"
  key                  = "nat_gateway.tfstate"
  }
}