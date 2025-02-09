locals {
  defaults = {
    tags = {
      Provisioner = "Terraform"
      # Application = var.cost_center # Remove after Application policy is gone
    }
  }

  resource_group_name    = module.resource_group_name.name
  public_ip_prefix_name  = module.public_ip_prefix_name.name
  nat_gateway_name       = module.nat_gateway_name.name
  location               = var.location

  public_ip_prefix_length = var.public_ip_prefix_length
  zones                   = var.zones
  idle_timeout_in_minutes = var.idle_timeout_in_minutes

  resource_group_tags    = merge(local.defaults.tags, module.resource_group_name.tags, var.tags)
  public_ip_prefix_tags  = merge(local.defaults.tags, module.public_ip_prefix_name.tags, var.tags)
  nat_gateway_tags       = merge(local.defaults.tags, module.nat_gateway_name.tags, var.tags)
  tags                   = merge(local.defaults.tags, var.tags)
}
