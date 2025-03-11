resource "azurerm_virtual_machine_scale_set_extension" "azure_monitor_agent" {
  count = local.azure_monitor_agent_enable ? 1 : 0

  name                          = join("-", [azurerm_linux_virtual_machine_scale_set.vmss.name, "monitor", "agent"])
  virtual_machine_scale_set_id  = azurerm_linux_virtual_machine_scale_set.vmss.id
  publisher                     = "Microsoft.EnterpriseCloud.Monitoring"
  type                          = "OmsAgentForLinux"
  type_handler_version          = "1.13"
  auto_upgrade_minor_version    = true

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

  depends_on = [
    azurerm_linux_virtual_machine_scale_set.vmss,
  ]
}

resource "azurerm_virtual_machine_scale_set_extension" "azure_dependency_agent" {
  count = local.azure_monitor_agent_enable ? (local.azure_monitor_agent_settings.enable_dependency_agent ? 1 : 0) : 0

  name                          = join("-", [azurerm_linux_virtual_machine_scale_set.vmss.name, "dependency", "agent"])
  virtual_machine_scale_set_id  = azurerm_linux_virtual_machine_scale_set.vmss.id
  publisher                     = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                          = "DependencyAgentLinux"
  type_handler_version          = "9.10"

  depends_on = [
    azurerm_linux_virtual_machine_scale_set.vmss,
    azurerm_virtual_machine_scale_set_extension.azure_monitor_agent,
  ]
}