resource "azurerm_virtual_machine_scale_set_extension" "custom_script" {
  count = local.custom_script_enable ? 1 : 0

  name                         = join("-", [azurerm_linux_virtual_machine_scale_set.vmss.name, "custom", "script"])
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.vmss.id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.0"

  settings = jsonencode({
    "skipDos2Unix": false
  })

  protected_settings = jsonencode(local.custom_script_protected_settings)
}
