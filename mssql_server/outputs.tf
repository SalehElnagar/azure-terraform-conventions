output "id" {
  value       = azurerm_mssql_server.mssql.id
  description = "the Azure SQL Server ID." 
}

output "name" {
  value       = azurerm_mssql_server.mssql.name
  description = "The Azure SQL Server name."
}

output "location" {
  value       = azurerm_mssql_server.mssql.location
  description = "the Azure SQL Server location." 
}

output "resource_group_name" {
  value       = azurerm_mssql_server.mssql.resource_group_name
  description = "the Azure SQL Server resource group name." 
}

output "fully_qualified_domain_name" {
  value       = azurerm_mssql_server.mssql.fully_qualified_domain_name
  description = "The fully qualified domain name of the Azure SQL Server." 
}
output "administrator_login" {
  value       = azurerm_mssql_server.mssql.administrator_login
  description = "The fully qualified domain name of the Azure SQL Server." 
}
output "administrator_login_password" {
  value       = azurerm_mssql_server.mssql.administrator_login_password
  description = "The fully qualified domain name of the Azure SQL Server." 
}

# output "identity_principal_id" {
#   value       = azurerm_mssql_server.mssql.identity[0].principal_id
#   description = "The System ID of the Azure SQL Server." 
# }

output "databases" {
  value = {for i, d in azurerm_mssql_database.mssql: i => {
    name            = d.name
    id              = d.id
    sku_name        = d.sku_name
    max_size_gb     = d.max_size_gb
    read_scale      = d.read_scale
    zone_redundant  = d.zone_redundant
  }}
}