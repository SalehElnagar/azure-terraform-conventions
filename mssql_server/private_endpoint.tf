resource "azurerm_private_endpoint" "mssql" {
  count = local.enable_private_endpoint ? 1 : 0

  name                 = join("-", ["pe", azurerm_mssql_server.mssql.name])
  location             = azurerm_mssql_server.mssql.location
  resource_group_name  = azurerm_mssql_server.mssql.resource_group_name
  subnet_id            = data.azurerm_subnet.private_endpoint[0].id

  private_service_connection {
    name                           = join("-", ["private", "connection", azurerm_mssql_server.mssql.name])
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.mssql.id
    subresource_names              = ["sqlServer"]
  }
}
