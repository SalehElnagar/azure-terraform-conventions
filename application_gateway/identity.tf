resource "azurerm_user_assigned_identity" "application_gateway" {
  count = local.create_user_identity  ? 1 : 0

  resource_group_name = local.resource_group_name
  location            = local.location

  name = join("-", ["mid", lower(local.name)])
}

# Allow Application Gateway to read the Key Vault
resource "azurerm_role_assignment" "key_vault_reader" {
  for_each = toset(local.key_vault_ids)

  scope                = each.value
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.application_gateway[0].principal_id
}

# Allow Application Gateway to read the Key Vault Secrets
resource "azurerm_role_assignment" "key_vault_secrets_reader" {
  for_each = toset(local.key_vault_ids)

  scope                = each.value
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.application_gateway[0].principal_id
}
