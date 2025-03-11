terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.35"
    } 
    random = {
      source  = "hashicorp/random"
      version = ">=2.0"
    }
  }
}