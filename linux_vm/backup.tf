resource "azurerm_backup_protected_vm" "vm" {
  count = local.enable_recovery_services_protection ? 1 : 0

  resource_group_name = data.azurerm_backup_policy_vm.vm_cluster[0].resource_group_name
  recovery_vault_name = data.azurerm_backup_policy_vm.vm_cluster[0].recovery_vault_name
  source_vm_id        = azurerm_linux_virtual_machine.vm.id
  backup_policy_id    = data.azurerm_backup_policy_vm.vm_cluster[0].id
}