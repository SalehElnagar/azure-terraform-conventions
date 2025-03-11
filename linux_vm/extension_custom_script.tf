resource "azurerm_virtual_machine_extension" "custom_script" {
  count = local.custom_script_enable ? 1 : 0

  name                 = join("-", [azurerm_linux_virtual_machine.vm.name, "custom", "script"])
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      "skipDos2Unix": false
    }
SETTINGS

  protected_settings = jsonencode(local.custom_script_protected_settings)

  tags = local.tags

  depends_on = [
    azurerm_linux_virtual_machine.vm,
    azurerm_network_interface_backend_address_pool_association.vm,
    azurerm_network_interface_nat_rule_association.vm,
    azurerm_network_interface_application_security_group_association.vm
  ]
}