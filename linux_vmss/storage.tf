resource "random_id" "vmss" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = local.resource_group_name
  }

  byte_length = 6
}

resource "azurerm_storage_account" "vmss" {
  name                     = join("", ["diag", substr(local.vmss_name_prefix, 0, 8), random_id.vmss.hex])
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = local.tags
}
