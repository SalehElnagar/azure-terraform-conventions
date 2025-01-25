# Allow TF Principal ID to manage the Key Vault itself (not keys)
resource "azurerm_role_assignment" "aks_key_vault_contributor" {
  scope                = azurerm_resource_group.aks.id
  role_definition_name = "Key Vault Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Allow TF Principal ID to manage the Key Vault keys
resource "azurerm_role_assignment" "aks_key_vault_crypto_officer" {
  scope                = azurerm_resource_group.aks.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault" "aks" {
  name                = local.key_vault_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  tenant_id           = data.azurerm_subscription.current.tenant_id

  sku_name = "standard"

  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  enabled_for_disk_encryption = false
  enable_rbac_authorization   = false

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = local.key_vault_tags

  depends_on = [
    azurerm_role_assignment.aks_key_vault_contributor,
    azurerm_role_assignment.aks_key_vault_crypto_officer
  ]

}

resource "azurerm_key_vault_access_policy" "aks-policy1" {
  key_vault_id = azurerm_key_vault.aks.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.internal_aks_cluster.identity_principal_id

  key_permissions = [
    "Get", "List",
  ]

  secret_permissions = [
    "Get", "list",
  ]
  certificate_permissions = [
    "Get", "list",
  ]
}
resource "azurerm_key_vault_access_policy" "aks-policy2" {
  key_vault_id = azurerm_key_vault.aks.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get", "List", "Update", "Create", "Import", "Backup", "Decrypt", "Delete", "Restore",
  ]

  secret_permissions = [
    "Get", "list", "Delete", "set", "Restore", "Recover",
  ]
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import", "Backup", "Delete", "Restore",
  ]
}