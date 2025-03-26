locals {
  defaults = {
    storage_account_kind             = "StorageV2"
    storage_account_tier             = "Standard"
    storage_account_replication_type = "LRS"
    storage_access_tier              = "Cool"
    storage_container_name           = "tfstate"
  }

  base_tags = {
    Provisioner = "Terraform"
  }

  storage_account_kind             = coalesce(var.storage_account_kind, local.defaults.storage_account_kind)
  storage_account_tier             = coalesce(var.storage_account_tier, local.defaults.storage_account_tier)
  storage_account_replication_type = coalesce(var.storage_account_replication_type, local.defaults.storage_account_replication_type)
  storage_access_tier              = coalesce(var.storage_access_tier, local.defaults.storage_access_tier)
  storage_container_name           = coalesce(var.storage_container_name, local.defaults.storage_container_name)

  tags = merge(local.base_tags, var.tags)
}

