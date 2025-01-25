resource "azurerm_resource_group" "container" {
  name     = local.resource_group_name
  location = local.location

  tags = local.resource_group_tags
}


resource "azurerm_container_registry" "container" {
  name                = local.container_registry_name
  resource_group_name = azurerm_resource_group.container.name
  location            = azurerm_resource_group.container.location
  sku                 = local.container_sku
  admin_enabled       = local.container_admin_enabled

  dynamic "georeplications" {
    for_each = local.container_georeplications

    content {
      location  = georeplications.value
      tags      = local.container_registry_tags
    }
  }

  tags = local.container_registry_tags
}