resource "azurerm_firewall_network_rule_collection" "firewall" {
  for_each = { for r in local.network_rule_collection : r.name => r if !local.firewall_policy_enabled }

  name                = each.key
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = data.azurerm_resource_group.firewall.name
  priority            = each.value.priority 
  action              = each.value.action

  dynamic "rule" {
    iterator = rule
    for_each = each.value.rules

    content {
      name                  = rule.key
      description           = lookup(rule.value, "description")
      source_addresses      = lookup(rule.value, "source_addresses")
      destination_addresses = lookup(rule.value, "destination_addresses")
      destination_fqdns     = lookup(rule.value, "destination_fqdns")
      destination_ports     = lookup(rule.value, "destination_ports")
      protocols             = lookup(rule.value, "protocols")
    }
  }
}