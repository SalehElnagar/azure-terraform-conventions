resource "azurerm_virtual_machine_extension" "vm_join_domain" {
  count = local.join_domain ? 1 : 0

  name                       = join("-", [azurerm_windows_virtual_machine.vm.name, "domain"])
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  # NOTE: the `OUPath` field is intentionally blank, to put it in the Computers OU
  //"OUPath": "",
  //OU=Development; OU=Servers; OU=Machines; DC=example; DC=com
  settings = <<SETTINGS
    {
        "Name": "${local.join_domain_settings.domain_name}",
        "OUPath": "${trimspace(local.join_domain_settings.domain_ou_path)}",
        "User": "${local.join_domain_settings.domain_user}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${local.join_domain_settings.domain_password}"
    }
SETTINGS

  tags = local.tags

  depends_on = [
    azurerm_windows_virtual_machine.vm,
    azurerm_virtual_machine_extension.custom_script
  ]
}