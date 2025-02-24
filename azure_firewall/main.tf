resource "azurerm_public_ip" "firewall" {
  name                = local.public_ip_name
  location            = data.azurerm_resource_group.firewall.location
  resource_group_name = data.azurerm_resource_group.firewall.name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = local.tags
}

resource "azurerm_firewall" "firewall" {
  name                = local.name
  location            = data.azurerm_resource_group.firewall.location
  resource_group_name = data.azurerm_resource_group.firewall.name
  sku_tier            = local.sku_tier
  zones               = local.zones
  firewall_policy_id  = local.firewall_policy_id
  
  dns_servers = local.dns_servers

  // TODO: make dynamic block to support more public IPs.
  ip_configuration {
    name                 = "configuration"
    subnet_id            = local.subnet_id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }

  threat_intel_mode = local.threat_intel_mode

  tags = local.tags
}