resource "azurerm_resource_group" "network" {
  name     = local.resource_group_name
  location = local.location

  tags = local.resource_group_tags
}

# Lock resource_group
# resource "azurerm_management_lock" "resource-group-level" {
#   name       = "RG-lock"
#   scope      = azurerm_resource_group.network.id
#   lock_level = "CanNotDelete"
#   notes      = "This Resource Group can't be deleted"
# }

resource "azurerm_private_dns_zone" "network" {
  name                = local.private_dns_zone_name
  resource_group_name = azurerm_resource_group.network.name

  tags = local.virtual_network_tags

  # TODO: Remove when bug is fixed.
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/6129
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

module "virtual_network" {
  source = "../../infrastructure-terraform-azurerm-network/modules/virtual_network"

  name                = local.virtual_network_name
  location            = local.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = local.virtual_network_address_space
  dns_servers         = local.virtual_network_dns_servers

  network_security_groups = local.network_security_group_map
  route_tables            = local.route_table_map
  subnets                 = local.virtual_network_subnets

  tags = local.virtual_network_tags

  depends_on = [
    azurerm_resource_group.network,
    azurerm_network_security_rule.network,
    azurerm_route_table.network,
    azurerm_route.network
  ]

}

# TODO: Remove lower() when bug is fixed.
# https://github.com/terraform-providers/terraform-provider-azurerm/issues/5985
resource "azurerm_private_dns_zone_virtual_network_link" "network" {
  name                  = lower(join("-", ["dns", "link", "autotime", module.virtual_network.name]))
  private_dns_zone_name = azurerm_private_dns_zone.network.name
  resource_group_name   = azurerm_private_dns_zone.network.resource_group_name
  virtual_network_id    = module.virtual_network.id
  
  registration_enabled = true

  tags = local.virtual_network_tags

  # TODO: Remove when bug is fixed.
  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/6129
  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}
