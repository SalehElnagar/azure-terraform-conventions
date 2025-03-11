resource "azurerm_mssql_server_security_alert_policy" "mssql" {
  resource_group_name        = azurerm_mssql_server.mssql.resource_group_name
  server_name                = azurerm_mssql_server.mssql.name
  state                      = "Enabled"
  storage_endpoint           = azurerm_storage_account.mssql.primary_blob_endpoint
  storage_account_access_key = azurerm_storage_account.mssql.primary_access_key

  email_account_admins  = local.security_email_account_admins
  email_addresses       = local.security_email_addresses

  retention_days = local.security_retention_days
}

resource "azurerm_mssql_server_vulnerability_assessment" "mssql" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.mssql.id
  storage_container_path          = format("%s%s/", azurerm_storage_account.mssql.primary_blob_endpoint, "scans")
  storage_account_access_key      = azurerm_storage_account.mssql.primary_access_key

  recurring_scans {
    enabled                   = true
    email_subscription_admins = local.security_email_account_admins
    emails                    = local.security_email_addresses
  }
}
