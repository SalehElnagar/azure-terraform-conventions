#https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/azure-disk-enc-windows
resource "azurerm_virtual_machine_extension" "disk_encryption" {
  count = local.encrypt_vm ? 1 : 0

  name                       = join("-", [azurerm_windows_virtual_machine.vm.name, "encrypt"])
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "AzureDiskEncryption"
  type_handler_version       = "2.2"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "EncryptionOperation": "${local.encryption_settings.encryption_operation}",
        "KeyVaultURL": "${local.encryption_settings.key_vault_url}",
        "KeyVaultResourceId": "${local.encryption_settings.key_vault_id}",					
        "KeyEncryptionKeyURL": "${local.encryption_settings.encryption_key_url}",
        "KekVaultResourceId": "${local.encryption_settings.key_vault_id}",					
        "KeyEncryptionAlgorithm": "${local.encryption_settings.encryption_algorithm}",
        "VolumeType": "${local.encryption_volume_type}"
    }
SETTINGS

  tags = local.tags

  depends_on = [
    azurerm_windows_virtual_machine.vm,
    azurerm_virtual_machine_extension.custom_script
  ]
}
