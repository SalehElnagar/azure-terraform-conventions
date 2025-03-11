// locals {
//   system_identities = [
//     for i in azurerm_windows_virtual_machine.vm.identity : i
//     if length(regexall(".*SystemAssigned.*", i.type)) > 0
//   ]
// }

output "id" {
  value = azurerm_windows_virtual_machine.vm.id
}

output "name" {
  value = azurerm_windows_virtual_machine.vm.name
}

output "identities" {
  value = data.azurerm_virtual_machine.vm.identity
}

output "system_identity_principal_id" {
  value = var.enable_system_identity ? data.azurerm_virtual_machine.vm.identity[0].principal_id : null
}

output "network_interface_ids" {
  value = azurerm_windows_virtual_machine.vm.network_interface_ids
}

output "private_ip_address" {
  value = azurerm_network_interface.vm.private_ip_address
}

# Will be deprecated from this module soon, use os_disks instead
output "os_disk" {
  value = azurerm_windows_virtual_machine.vm.os_disk[0]
}

output "os_disks" {
  value = [
    for disk in azurerm_windows_virtual_machine.vm.os_disk: {
      name                  = disk.name
      caching               = disk.caching
      storage_account_type  = disk.storage_account_type
  }]
}

# Will be deprecated from this module soon, use data_disks instead
output "data_disk_ids" {
  value = [ for disk in azurerm_managed_disk.data : disk.id ]
}

output "data_disks" {
  value = [
    for disk in azurerm_managed_disk.data: {
      name                  = disk.name
      id                    = disk.id
      storage_account_type  = disk.storage_account_type
  }]
}

output "storage_account_id" {
  value = azurerm_storage_account.vm.id
}

output "storage_account_primary_blob_endpoint" {
  value = azurerm_storage_account.vm.primary_blob_endpoint
}

output "storage_account_primary_access_key" {
  value = azurerm_storage_account.vm.primary_access_key 
}
