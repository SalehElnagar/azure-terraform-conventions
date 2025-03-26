resource "azurerm_resource_group" "terraform_state" {
  name     = var.resource_group_name
  location = var.location

  tags = local.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_account" "terraform_state" {
  name                      = var.storage_account_name
  resource_group_name       = azurerm_resource_group.terraform_state.name
  location                  = azurerm_resource_group.terraform_state.location
  account_kind              = local.storage_account_kind
  account_tier              = local.storage_account_tier
  account_replication_type  = local.storage_account_replication_type
  access_tier               = local.storage_access_tier
  enable_https_traffic_only = true

  tags = local.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "terraform_state" {
  name                 = local.storage_container_name
  storage_account_name = azurerm_storage_account.terraform_state.name

  lifecycle {
    prevent_destroy = true
  }
}

