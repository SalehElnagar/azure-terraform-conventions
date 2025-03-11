resource "random_id" "mssql_storage" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = local.resource_group_name
  }

  byte_length = 6
}

resource "azurerm_storage_account" "mssql" {
  name                     = lower(join("", ["sa", substr(replace(local.name, "-", ""), 0, 7), random_id.mssql_storage.hex]))
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = local.tags
}

# resource "azurerm_role_assignment" "sql_server_contributor" {
#   scope                 = azurerm_storage_account.mssql.id
#   role_definition_name  = "Storage Blob Data Contributor"
#   principal_id          = azurerm_mssql_server.mssql.identity[0].principal_id
# }
