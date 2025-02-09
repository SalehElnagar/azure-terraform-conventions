locals {

  defaults = {

    public_ip_allocation_method  = "Dynamic"
    private_ip_allocation_method = "Dynamic"
    sku                          = "Basic"

    probe_interval_in_seconds = 15
    probe_number_of_probes    = 2

    rule_idle_timeout_in_minutes = 4
  }

  name                = coalesce(var.name, try(module.lb_name.name, var.name))
  resource_group_name = var.resource_group_name
  sku                 = coalesce(var.sku, local.defaults.sku)

  is_public_load_balancer   = lower(var.type) == "public"
  is_standard_load_balancer = lower(local.sku) == "standard"

  frontend_name                = var.frontend_name
  public_ip_name               = var.public_ip_name
  public_ip_allocation_method  = local.is_standard_load_balancer ? "Static" : coalesce(var.public_ip_allocation_method, local.defaults.public_ip_allocation_method)
  private_ip_subnet_id         = var.private_ip_subnet_id
  private_ip_allocation_method = var.private_ip_allocation_method
  private_ip_address           = var.private_ip_address
  frontend_zones               = null

  backend_name = var.backend_name

  probes = var.probes
  probe_default_interval_in_seconds = coalesce(var.probe_default_interval_in_seconds, local.defaults.probe_interval_in_seconds)
  probe_default_number_of_probes    = coalesce(var.probe_default_number_of_probes, local.defaults.probe_number_of_probes)

  rules = var.rules
  rule_default_idle_timeout_in_minutes = coalesce(var.rule_default_idle_timeout_in_minutes, local.defaults.rule_idle_timeout_in_minutes)

  outbound_rules = var.outbound_rules

  tags = merge(try(module.tags.tags, {}), try(var.tags, {}))

}
#load_balancer_ip_address = cidrhost(data.azurerm_subnet.network.address_prefix, local.virtual_network_load_balancer_host_offset)
//   load_balancer_front_ends = [
//     {
//       name                  = "NFSFrontEnd"
//       subnet_id             = data.azurerm_subnet.network.id
//       private_ip_address    = cidrhost(data.azurerm_subnet.network.address_prefix, local.virtual_network_load_balancer_host_offset)
//     }
//   ]

//   load_balancer_probes = [
//     {
//       name = "NFSEndPointProbe"
//       port = 61000
//       protocol = "Tcp"
//     }
//   ]

//   load_balancer_rules = {

//     rule1 = {
//       name                            = "SQLAlwaysOnEndPoint"
//       frontend_ip_configuration_name  = "SQLAlwaysOnFrontEnd"
//       probe_name                      = "NFSEndPointProbe"
//       protocol                        = "Tcp"
//       frontend_port                   = 2049
//       backend_port                    = 2049
//       enable_floating_ip              = true
//       idleTimeoutInMinutes            = 10
//     }
//   }

// }
