resource "azurerm_firewall_nat_rule_collection" "firewall" {
  for_each = { for r in local.nat_rule_collection : r.name => r if !local.firewall_policy_enabled }

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
      destination_addresses = [azurerm_public_ip.firewall.ip_address]
      destination_ports     = lookup(rule.value, "destination_ports")
      protocols             = lookup(rule.value, "protocols")
      source_addresses      = lookup(rule.value, "source_addresses")
      translated_address    = lookup(rule.value, "translated_address")
      translated_port       = lookup(rule.value, "translated_port")
    }
  }
}