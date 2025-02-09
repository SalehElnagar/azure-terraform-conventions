locals {
  defaults = {
    tags = {
      Provisioner = "Terraform"
    }
  }

  resource_group_name           = module.resource_group_name.name
  application_gateway_name      = module.application_gateway_name.name
  location                      = var.location

  resource_group_tags           = merge(module.resource_group_name.tags, local.defaults.tags)
  application_gateway_tags      = merge(module.application_gateway_name.tags, local.defaults.tags)

}
