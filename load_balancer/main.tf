resource "azurerm_public_ip" "lb" {
  count = local.is_public_load_balancer ? 1 : 0

  name                = local.public_ip_name
  location            = data.azurerm_resource_group.lb.location
  resource_group_name = data.azurerm_resource_group.lb.name
  sku                 = local.sku
  allocation_method   = local.public_ip_allocation_method

  tags = local.tags
}

resource "azurerm_lb" "lb" {
  name                = local.name
  location            = data.azurerm_resource_group.lb.location
  resource_group_name = data.azurerm_resource_group.lb.name
  sku                 = local.sku

  frontend_ip_configuration {
    name                          = local.frontend_name
    public_ip_address_id          = local.is_public_load_balancer ? azurerm_public_ip.lb[0].id : null
    public_ip_prefix_id           = null
    subnet_id                     = local.private_ip_subnet_id
    private_ip_address            = local.private_ip_address
    private_ip_address_allocation = local.private_ip_allocation_method
    zones                         = local.frontend_zones
  }

  tags = local.tags
}

resource "azurerm_lb_backend_address_pool" "lb" {
  resource_group_name = azurerm_lb.lb.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = local.backend_name
}

resource "azurerm_lb_probe" "lb" {
  for_each = { for p in local.probes : p.name => p}

  name                = lookup(each.value, "name")
  resource_group_name = azurerm_lb.lb.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = lookup(each.value, "protocol", "Tcp")
  port                = lookup(each.value, "port")
  request_path        = lookup(each.value, "request_path", null)
  interval_in_seconds = lookup(each.value, "interval_in_seconds", local.probe_default_interval_in_seconds)
  number_of_probes    = lookup(each.value, "number_of_probes", local.probe_default_number_of_probes)
}

resource "azurerm_lb_rule" "lb" {
  for_each = { for r in local.rules : r.name => r}

  name                           = lookup(each.value, "name")
  resource_group_name            = azurerm_lb.lb.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  frontend_ip_configuration_name = lookup(each.value, "frontend_ip_configuration_name")
  protocol                       = lookup(each.value, "protocol", "Tcp")
  frontend_port                  = lookup(each.value, "frontend_port")
  backend_port                   = lookup(each.value, "backend_port", lookup(each.value, "frontend_port"))
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb.id
  probe_id                       = azurerm_lb_probe.lb[lookup(each.value, "probe_name")].id
  enable_floating_ip             = lookup(each.value, "enable_floating_ip", false)
  idle_timeout_in_minutes        = lookup(each.value, "idle_timeout_in_minutes", local.rule_default_idle_timeout_in_minutes)
  load_distribution              = lookup(each.value, "load_distribution", "Default")
  disable_outbound_snat          = lookup(each.value, "disable_outbound_snat", false)
}

resource "azurerm_lb_outbound_rule" "lb" {
  for_each = { for o in local.outbound_rules : o.name => o}

  name                      = lookup(each.value, "name")
  resource_group_name       = azurerm_lb.lb.resource_group_name
  loadbalancer_id           = azurerm_lb.lb.id
  backend_address_pool_id   = azurerm_lb_backend_address_pool.lb.id
  protocol                  = lookup(each.value, "protocol", "All")
  enable_tcp_reset          = lookup(each.value, "enable_tcp_reset", null)
  allocated_outbound_ports  = lookup(each.value, "allocated_outbound_ports", null)
  idle_timeout_in_minutes   = lookup(each.value, "idle_timeout_in_minutes", local.rule_default_idle_timeout_in_minutes)
  
  dynamic "frontend_ip_configuration" {
    for_each = lookup(each.value, "frontend_names")

    content {
      name = frontend_ip_configuration.value
    }
  }

}


