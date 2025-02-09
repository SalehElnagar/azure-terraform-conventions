resource "azurerm_resource_group" "nat" {
  name     = local.resource_group_name
  location = local.location

  tags = local.resource_group_tags
}

# Lock resource_group
# resource "azurerm_management_lock" "resource-group-level" {
# name       = "RG-lock"
#  scope      = azurerm_resource_group.nat.id
#  lock_level = "CanNotDelete"
#  notes      = "This Resource Group can't be deleted"
# }

resource "azurerm_public_ip_prefix" "nat" {
  name                = local.public_ip_prefix_name
  location            = local.location
  resource_group_name = azurerm_resource_group.nat.name
  sku           = "Standard"
  prefix_length = local.public_ip_prefix_length
  availability_zone     = "No-Zone"
  tags = local.public_ip_prefix_tags
}


resource "azurerm_nat_gateway" "nat" {
  name                    = local.nat_gateway_name
  location                = azurerm_resource_group.nat.location
  resource_group_name     = azurerm_resource_group.nat.name

  public_ip_prefix_ids    = [azurerm_public_ip_prefix.nat.id]
  sku_name                = "Standard"
  idle_timeout_in_minutes = local.idle_timeout_in_minutes
  zones                   = []

  tags = local.nat_gateway_tags
}
