resource "random_id" "vm" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = local.resource_group_name
  }

  byte_length = 3
}

resource "azurerm_storage_account" "vm" {
  name                     = join("", ["diag", substr(local.virtual_machine_purpose, 0, 8), random_id.vm.hex])
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = local.tags
}