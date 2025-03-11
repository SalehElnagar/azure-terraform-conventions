resource "azurerm_mssql_database" "mssql_replicated" {
  for_each = local.replicated_databases

  create_mode                 = "OnlineSecondary"
  creation_source_database_id = each.value.source_database_id

  name           = each.key
  server_id      = azurerm_mssql_server.mssql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "BasePrice"
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
      license_type,
      # https://github.com/terraform-providers/terraform-provider-azurerm/issues/9067
      long_term_retention_policy[0].week_of_year,
      long_term_retention_policy[0].yearly_retention,
    ]
  }
}