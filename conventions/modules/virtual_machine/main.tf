locals {

  defaults = {
    label_order = ["location", "role", "environment", "environment_instance", "name", "instance"]
    tags        = {}
  }

  label_order           = local.defaults.label_order
  delimiter             = ""
  location              = var.location
  role                  = var.role
  environment           = var.environment
  environment_instance  = var.environment_instance
  name                  = var.name
  instance              = var.instance
  tags                  = merge(var.tags, local.defaults.tags)

  mapped_location             = module.common.locations[lower(local.location)]
  mapped_role                 = local.roles[lower(local.role)]
  mapped_environment          = module.common.vm_environments[lower(local.environment)]
  padded_environment_instance = local.environment_instance == 0 ? "" : local.environment_instance
  padded_instance             = local.instance == 0 ? "" : format("%02s", local.instance)

  name_context = {
    location              = local.mapped_location
    role                  = local.mapped_role
    environment           = local.mapped_environment
    environment_instance  = local.padded_environment_instance
    name                  = local.name
    instance              = local.padded_instance
  }

  labels = [for l in local.label_order : lower(local.name_context[l]) if length(tostring(local.name_context[l])) > 0]

  resource_name = lower(join(local.delimiter, local.labels))
  # Generate tags (don't include tags with empty values)
  tags_context = {
    name                    = local.name
    role                    = local.role
    instance                = local.instance
    environment             = local.environment
    "EnvironmentInstance"   = local.environment_instance
    location                = local.mapped_location
  }

  generated_tags = { for t in keys(local.tags_context) : title(t) => local.tags_context[t] if length(tostring(local.tags_context[t])) > 0 }

  resource_tags = merge(module.common.base_tags, local.generated_tags, local.tags)

}

