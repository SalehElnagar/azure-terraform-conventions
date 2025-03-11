resource "azurerm_sql_firewall_rule" "azure" {
  count = var.firewall_allow_azure_access ? 1 : 0

  name                = "AllowAccessToAzure"
  resource_group_name = azurerm_mssql_server.mssql.resource_group_name
  server_name         = azurerm_mssql_server.mssql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_firewall_rule" "ip" {
  for_each = { for r in local.firewall_ip_rules: r.name => r }

  name                = each.key
  resource_group_name = azurerm_mssql_server.mssql.resource_group_name
  server_name         = azurerm_mssql_server.mssql.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = lookup(each.value, "end_ip_address", each.value.start_ip_address)
}

resource "azurerm_sql_virtual_network_rule" "vnet" {
  for_each = local.firewall_virtual_network_rules

  name                = each.key
  resource_group_name = azurerm_mssql_server.mssql.resource_group_name
  server_name         = azurerm_mssql_server.mssql.name
  subnet_id           = each.value

  ignore_missing_vnet_service_endpoint = true
}
