// locals {
//   system_identities = [
//     for i in azurerm_linux_virtual_machine.vm.identity : i
//     if length(regexall(".*SystemAssigned.*", i.type)) > 0
//   ]
// }

output "id" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.id
}

output "name" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.name
}

output "resource_group_name" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.resource_group_name
}

output "identities" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.identity
}

output "system_identity_principal_id" {
  value = var.enable_system_identity ? azurerm_linux_virtual_machine_scale_set.vmss.identity[0].principal_id : null
}

// output "storage_account_id" {
//   value = azurerm_storage_account.vmss.id
// }

// output "storage_account_primary_blob_endpoint" {
//   value = azurerm_storage_account.vmss.primary_blob_endpoint
// }

// output "storage_account_primary_access_key" {
//   value = azurerm_storage_account.vmss.primary_access_key 
// }