resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  count = local.azure_monitor_agent_enable ? 1 : 0

  name                        = join("-", [azurerm_linux_virtual_machine.vm.name, "monitor", "agent"])
  virtual_machine_id          = azurerm_linux_virtual_machine.vm.id
  publisher                   = "Microsoft.EnterpriseCloud.Monitoring"
  type                        = "OmsAgentForLinux"
  type_handler_version        = "1.12"
  auto_upgrade_minor_version  = true

  settings = <<SETTINGS
    {
      "workspaceId": "${local.azure_monitor_agent_settings.workspace_id}"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
      "workspaceKey": "${local.azure_monitor_agent_settings.workspace_key}"
    }
SETTINGS

  tags = local.tags

  depends_on = [
    azurerm_linux_virtual_machine.vm,
    azurerm_network_interface_backend_address_pool_association.vm
  ]
}

resource "azurerm_virtual_machine_extension" "azure_dependency_agent" {
  count = local.azure_monitor_agent_enable ? (local.azure_monitor_agent_settings.enable_dependency_agent ? 1 : 0) : 0

  name                 = join("-", [azurerm_linux_virtual_machine.vm.name, "dependency", "agent"])
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                 = "DependencyAgentLinux"
  type_handler_version = "9.10"

  tags = local.tags

  depends_on = [
    azurerm_linux_virtual_machine.vm,
    azurerm_virtual_machine_extension.azure_monitor_agent
  ]
}