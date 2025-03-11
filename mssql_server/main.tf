resource "random_string" "mssql_password" {
  length           = 32
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  special          = true
  min_special      = 1
  override_special = "!@#*%"
}

resource "azurerm_mssql_server" "mssql" {
  name                         = lower(local.name)
  resource_group_name          = local.resource_group_name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = local.administrator_login
  administrator_login_password = local.administrator_login_password

#   azuread_administrator {
#     login_username = local.azuread_administrator_login
#     object_id      = local.azuread_administrator_object_id
#   }

#   connection_policy = local.connection_policy

#   dynamic "identity" {
#     for_each = local.identities

#     content {
#       type = identity.value
#     }
#   }

#   tags = local.tags
# }

# resource "azurerm_mssql_server_extended_auditing_policy" "mssql" {
#   server_id                   = azurerm_mssql_server.mssql.id
#   storage_endpoint            = azurerm_storage_account.mssql.primary_blob_endpoint
#   storage_account_access_key  = azurerm_storage_account.mssql.primary_access_key
#   retention_in_days           = local.audit_retention_days
}
