resource "azurerm_managed_disk" "data" {
  for_each = { for d in local.data_disks : d.name_part => d }

  name                  = join("_", [azurerm_windows_virtual_machine.vm.name, each.key])
  location              = azurerm_windows_virtual_machine.vm.location
  resource_group_name   = azurerm_windows_virtual_machine.vm.resource_group_name
  create_option         = coalesce(lookup(each.value, "create_option", local.data_disk_default_create_option), local.data_disk_default_create_option)
  disk_size_gb          = coalesce(lookup(each.value, "disk_size_gb", local.data_disk_default_size_gb), local.data_disk_default_size_gb)
  storage_account_type  = coalesce(lookup(each.value, "storage_account_type", local.data_disk_default_storage_account_type), local.data_disk_default_storage_account_type)
  disk_encryption_set_id  = local.disk_encryption_set_id

  zones = local.availability_zone != null ? [local.availability_zone] : null

  lifecycle {
    ignore_changes = [
      create_option,
      encryption_settings,
    ]
  }

  tags = local.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  for_each = { for d in local.data_disks : d.name_part => d }

  managed_disk_id           = azurerm_managed_disk.data[each.key].id
  virtual_machine_id        = azurerm_windows_virtual_machine.vm.id
  lun                       = each.value.lun
  caching                   = coalesce(lookup(each.value, "caching", local.data_disk_default_caching), local.data_disk_default_caching)
  write_accelerator_enabled = coalesce(lookup(each.value, "write_accelerator_enabled", false), false)

  lifecycle {
    ignore_changes = [
      create_option
    ]
  }
}
