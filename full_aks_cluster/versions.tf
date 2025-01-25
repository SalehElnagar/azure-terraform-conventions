terraform {
  required_version = ">= 0.15"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.47"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>1.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.0"
    }
  }
}
