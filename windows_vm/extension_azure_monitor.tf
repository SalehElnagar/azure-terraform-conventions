resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  count = local.azure_monitor_agent_enable ? 1 : 0

  name                 = join("-", [azurerm_windows_virtual_machine.vm.name, "monitor"])
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

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

  depends_on = [azurerm_windows_virtual_machine.vm]
}

resource "azurerm_virtual_machine_extension" "azure_dependency_agent" {
  count = local.azure_monitor_agent_enable ? (local.azure_monitor_agent_settings.enable_dependency_agent ? 1 : 0) : 0

  name                 = join("-", [azurerm_windows_virtual_machine.vm.name, "dependency", "agent"])
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                 = "DependencyAgentWindows"
  type_handler_version = "9.10"

  tags = local.tags

  depends_on = [
    azurerm_windows_virtual_machine.vm,
    azurerm_virtual_machine_extension.azure_monitor_agent
  ]
}
