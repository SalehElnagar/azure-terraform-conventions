locals {

  name            = coalesce(var.name, try(module.firewall_name.name, var.name))
  location        = coalesce(var.location, data.azurerm_resource_group.firewall.location)
  public_ip_name  = coalesce(var.public_ip_name, join("-", ["IP", var.name]))

  firewall_policy_enabled = var.firewall_policy_id != null
  firewall_policy_id      = var.firewall_policy_id

  sku_tier = var.sku_tier

  subnet_id = var.subnet_id

  dns_servers = length(var.dns_servers) > 0 && var.firewall_policy_id == null ? var.dns_servers : null 

  threat_intel_mode = var.threat_intel_mode

  zones = var.zones

  application_rule_collection = var.application_rule_collection != null ? var.application_rule_collection : []
  network_rule_collection     = var.network_rule_collection != null ? var.network_rule_collection : []
  nat_rule_collection         = var.nat_rule_collection != null ? var.nat_rule_collection : []

  tags = merge(try(module.tags.tags, {}), try(var.tags, {}))
}
