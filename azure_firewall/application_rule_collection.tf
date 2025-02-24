resource "azurerm_firewall_application_rule_collection" "firewall" {
  for_each = { for r in local.application_rule_collection : r.name => r if !local.firewall_policy_enabled }

  name                = each.key
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = data.azurerm_resource_group.firewall.name
  priority            = each.value.priority 
  action              = each.value.action

  dynamic "rule" {
    for_each = each.value.rules

    content {
      name                  = rule.key
      description           = lookup(rule.value, "description")
      source_addresses      = lookup(rule.value, "source_addresses")
      fqdn_tags             = lookup(rule.value, "fqdn_tags")
      target_fqdns          = lookup(rule.value, "target_fqdns")

      dynamic "protocol" {
        for_each = rule.value.protocols
        
        content {
          port = protocol.value.port
          type = protocol.value.type
        }
      }

    }
  }
}
