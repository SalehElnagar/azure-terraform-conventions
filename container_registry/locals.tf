locals {
  defaults = {
    container_sku = "Standard"

    tags = {
      Provisioner = "Terraform"
    }
  }

  resource_group_name     = module.resource_group_name.name
  container_registry_name = module.container_registry_name.name
  location                = var.location

  container_sku             = coalesce(var.container_sku, local.defaults.container_sku)
  container_admin_enabled   = var.container_admin_enabled
  container_georeplications = var.container_georeplications

  resource_group_tags     = merge(module.resource_group_name.tags, local.defaults.tags)
  container_registry_tags = merge(module.container_registry_name.tags, local.defaults.tags)
  tags                    = merge(module.tags.tags, local.defaults.tags)
}