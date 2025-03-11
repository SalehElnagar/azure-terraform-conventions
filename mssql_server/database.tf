resource "azurerm_mssql_database" "mssql" {
  for_each = local.databases

  name           = each.key
  server_id      = azurerm_mssql_server.mssql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "BasePrice" #"LicenseIncluded" #
  max_size_gb    = lookup(each.value, "max_size_db", null) 
  read_scale     = each.value.read_scale
  sku_name       = each.value.sku_name
  zone_redundant = each.value.zone_redundant

  dynamic "short_term_retention_policy" {
    for_each = local.enable_database_retention ? ["short_term_retention_policy"] : []
    content {
      retention_days = local.database_short_term_retention_days
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = local.enable_database_retention ? ["long_term_retention_policy"] : []
    content {
      weekly_retention  = local.database_long_term_retention.weekly_retention
      monthly_retention = local.database_long_term_retention.monthly_retention
      yearly_retention  = local.database_long_term_retention.yearly_retention
      week_of_year      = local.database_long_term_retention.week_of_year
    }
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
      create_mode,
      creation_source_database_id,
      license_type,
      # https://github.com/terraform-providers/terraform-provider-azurerm/issues/9067
      long_term_retention_policy[0].week_of_year,
      long_term_retention_policy[0].yearly_retention,
    ]
  }
}

resource "azurerm_mssql_database_extended_auditing_policy" "mssql" {
  for_each = local.databases

  database_id                 = azurerm_mssql_database.mssql[each.key].id
  storage_endpoint            = azurerm_storage_account.mssql.primary_blob_endpoint
  storage_account_access_key  = azurerm_storage_account.mssql.primary_access_key
  retention_in_days           = local.audit_retention_days
}
