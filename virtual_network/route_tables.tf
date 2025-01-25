resource "azurerm_route_table" "network" {
  for_each = { for r in local.route_tables : r.name => r }

  name                          = join(local.rt_delimiter, compact(flatten([local.rt_name_prefix, each.value.attributes, local.rt_name_suffix])))
  location                      = azurerm_resource_group.network.location
  resource_group_name           = azurerm_resource_group.network.name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation

  tags = local.resource_group_tags
}

locals {
  flattened_routes = flatten([
    for rt in local.route_tables : [
      for route_name, route in coalesce(rt.routes, {}) : merge({
        route_table_name  = rt.name, 
        route_name        = route_name 
      }, route)
    ]
  ])
}

resource "azurerm_route" "network" {
  for_each = { for r in local.flattened_routes : join(".", [r.route_table_name, r.route_name]) => r }

  name                   = each.value.route_name
  resource_group_name    = azurerm_route_table.network[each.value.route_table_name].resource_group_name
  route_table_name       = azurerm_route_table.network[each.value.route_table_name].name
  address_prefix         = lookup(each.value, "address_prefix")
  next_hop_type          = lookup(each.value, "next_hop_type")
  next_hop_in_ip_address = lookup(each.value, "next_hop_in_ip_address", null)
}
