resource "azurerm_virtual_machine_extension" "custom_script" {
  count = local.custom_script_enable ? 1 : 0

  name                       = join("-", [azurerm_windows_virtual_machine.vm.name, "custom", "script"])
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true

  protected_settings = jsonencode(local.custom_script_protected_settings)

  tags = local.tags

  depends_on = [azurerm_windows_virtual_machine.vm]
}


