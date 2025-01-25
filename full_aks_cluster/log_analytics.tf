resource "azurerm_log_analytics_workspace" "aks" {
  name                = local.log_analytics_workspace_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 2

  # https://github.com/Azure/AKS/issues/1924
  internet_ingestion_enabled  = true
  internet_query_enabled      = true

  tags = local.log_analytics_workspace_tags
}

resource "azurerm_log_analytics_solution" "aks" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.aks.location
  resource_group_name   = azurerm_log_analytics_workspace.aks.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.aks.id
  workspace_name        = azurerm_log_analytics_workspace.aks.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
