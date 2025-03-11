locals {
  defaults = {
    administrator_login         = "sqladmin"
    azuread_administrator_login = "dbadmin"
  }

  name                = coalesce(var.name, try(module.sql_server_name.name, var.name))
  resource_group_name = var.resource_group_name
  location            = var.location

  # SQL accounts
  administrator_login = coalesce(var.administrator_login, local.defaults.administrator_login)
  administrator_login_password = coalesce(
    var.administrator_login_password,
    random_string.mssql_password.result
  )
  azuread_administrator_login     = coalesce(var.azuread_administrator_login, local.defaults.azuread_administrator_login)
  azuread_administrator_object_id = var.azuread_administrator_object_id

  connection_policy = var.connection_policy

  # Private Endpoint
  enable_private_endpoint = var.private_endpoint != null ? true : false
  private_endpoint        = var.private_endpoint

  # Security and Audit
  audit_retention_days          = var.audit_retention_days
  security_retention_days       = var.security_retention_days
  security_email_account_admins = var.security_email_account_admins
  security_email_addresses      = var.security_email_addresses

  # Firewall Settings
  firewall_allow_azure_access     = var.firewall_allow_azure_access
  firewall_ip_rules               = [for r in var.firewall_ip_rules : {
    name             = coalesce(r.name, format("Client_%s", r.start_ip_address))
    start_ip_address = r.start_ip_address
    end_ip_address   = coalesce(r.end_ip_address, r.start_ip_address)
  }]
  firewall_virtual_network_rules  = var.firewall_virtual_network_rules

  # Encryption
  enable_data_encryption = var.data_encryption != null ? true : false
  data_encryption        = var.data_encryption

  # Managed Identities
  enable_system_identity = var.enable_system_identity || local.enable_data_encryption
  identities             = (var.enable_system_identity || local.enable_data_encryption) ? ["SystemAssigned"] : []

  # Database Retention
  enable_database_retention           = var.enable_database_retention
  database_short_term_retention_days  = var.database_short_term_retention_days
  database_long_term_retention        = var.database_long_term_retention 
  
  # Databases
  databases           = defaults(var.databases, {
    read_scale     = false
    sku_name       = "S0"
    zone_redundant = false
  })
  replicated_databases = defaults(var.replicated_databases, {
    read_scale     = false
    sku_name       = "S0"
    zone_redundant = false
  })

  # Tags
  tags = merge(try(module.tags.tags, {}), try(var.tags, {}))
}
