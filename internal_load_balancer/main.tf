resource "azurerm_lb" "lb" {
  name                = local.name
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = local.sku

  dynamic "frontend_ip_configuration" {
    for_each = local.frontend_ip_configurations

    content {
      name                          = frontend_ip_configuration.value.name
      subnet_id                     = frontend_ip_configuration.value.subnet_id
      private_ip_address            = frontend_ip_configuration.value.private_ip_address
      private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address_allocation
      zones                         = frontend_ip_configuration.value.zones
    }
  }

  tags = local.tags
}

resource "azurerm_lb_backend_address_pool" "lb" {
  for_each = toset(local.backend_address_pool_names)

  loadbalancer_id     = azurerm_lb.lb.id
  name                = each.key
}

resource "azurerm_lb_probe" "lb" {
  for_each = { for p in local.probes : p.name => p}

  name                = lookup(each.value, "name")
  resource_group_name = azurerm_lb.lb.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = lookup(each.value, "protocol", "Tcp")
  port                = lookup(each.value, "port")
  request_path        = lookup(each.value, "request_path", null)
  interval_in_seconds = lookup(each.value, "interval_in_seconds", local.default_probe_interval_in_seconds)
  number_of_probes    = lookup(each.value, "number_of_probes", local.default_probe_number_of_probes)
}

resource "azurerm_lb_rule" "lb" {
  for_each = { for r in local.rules : r.name => r}

  name                           = lookup(each.value, "name")
  resource_group_name            = azurerm_lb.lb.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  frontend_ip_configuration_name = lookup(each.value, "frontend_ip_configuration_name", local.default_frontend_name)
  protocol                       = lookup(each.value, "protocol", "Tcp")
  frontend_port                  = lookup(each.value, "frontend_port")
  backend_port                   = lookup(each.value, "backend_port", lookup(each.value, "frontend_port"))
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb[lookup(each.value, "backend_address_pool_name", local.defaults.backend_address_pool_name)].id
  probe_id                       = azurerm_lb_probe.lb[lookup(each.value, "probe_name")].id
  enable_floating_ip             = lookup(each.value, "enable_floating_ip", false)
  idle_timeout_in_minutes        = lookup(each.value, "idle_timeout_in_minutes", local.default_rule_idle_timeout_in_minutes)
  load_distribution              = lookup(each.value, "load_distribution", "Default")
  disable_outbound_snat          = lookup(each.value, "disable_outbound_snat", false)
}