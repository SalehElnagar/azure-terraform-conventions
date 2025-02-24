locals {

  defaults = {

    private_ip_address_allocation = "Dynamic"

    backend_address_pool_name = "BackEndAddressPool"

    probe_interval_in_seconds = 15
    probe_number_of_probes    = 2

    rule_idle_timeout_in_minutes = 4
  }

  name                = coalesce(var.name, try(module.lb_name.name, var.name))
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  zones               = var.zones

  is_standard_load_balancer = lower(local.sku) == "standard"

  default_frontend_name                 = var.default_frontend_name
  default_private_ip_allocation_method  = coalesce(var.default_private_ip_address_allocation, local.defaults.private_ip_address_allocation)
  default_frontend_ip_configuration     = {
    name                          = var.default_frontend_name
    subnet_id                     = var.default_subnet_id
    private_ip_address            = var.default_frontend_private_ip_address
    private_ip_address_allocation = var.default_private_ip_address_allocation
    zones                         = var.zones
  }
  
  frontend_ip_configurations_is_null_or_empty = var.frontend_ip_configurations != null ? length(var.frontend_ip_configurations) == 0 : true
  frontend_ip_configurations = (local.frontend_ip_configurations_is_null_or_empty ? [local.default_frontend_ip_configuration] :
    [ for f in var.frontend_ip_configurations : {
      name                          = f.name
      subnet_id                     = lookup(f, "subnet_id", var.default_subnet_id)
      private_ip_address            = lookup(f, "private_ip_address", null)
      private_ip_address_allocation = lookup(f, "private_ip_address_allocation", var.default_private_ip_address_allocation)
      zones                         = lookup(f, "zones", var.zones)
    }])
  backend_address_pool_names = var.backend_address_pool_names != null ? var.backend_address_pool_names : [local.defaults.backend_address_pool_name]

  probes                            = var.probes
  default_probe_interval_in_seconds = coalesce(var.default_probe_interval_in_seconds, local.defaults.probe_interval_in_seconds)
  default_probe_number_of_probes    = coalesce(var.default_probe_number_of_probes, local.defaults.probe_number_of_probes)

  rules                                = var.rules
  default_rule_idle_timeout_in_minutes = coalesce(var.default_rule_idle_timeout_in_minutes, local.defaults.rule_idle_timeout_in_minutes)

  tags = merge(try(module.tags.tags, {}), try(var.tags, {}))

}
