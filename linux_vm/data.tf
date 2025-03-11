data "azurerm_subscription" "current" {}

data "azurerm_role_definition" "vm" {
  for_each = toset(local.system_identity_role_assignments)

  name  = each.key
  scope = data.azurerm_subscription.current.id
}

data "azurerm_backup_policy_vm" "vm_cluster" {
  count = local.enable_recovery_services_protection ? 1 : 0

  name                = local.recovery_services_protection_policy.name
  recovery_vault_name = local.recovery_services_protection_policy.recovery_vault_name
  resource_group_name = local.recovery_services_protection_policy.resource_group_name
}
