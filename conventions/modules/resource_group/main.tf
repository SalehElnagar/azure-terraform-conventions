locals {
  defaults = {
    label_order         = ["prefix", "location", "namespace", "environment_instance", "purpose", "attributes", "environment"]
    delimiter           = "-"
    regex_replace_chars = "/[^a-zA-Z0-9-]/"
    replacement         = ""
  }

  options = {
    standardize             = try(var.options.standardize, true)
    delimiter               = try(var.options.delimiter, null)
    regex_replace_chars     = try(var.options.regex_replace_chars, null)
    include_environment     = try(var.options.include_environment, true)
    use_short_environment   = try(var.options.use_short_environment, false)
    include_global_location = try(var.options.include_global_location, true)
    label_order             = try(var.options.label_order, [])
  }

  tags_config = {
    include_generated = try(var.tags.include_generated, true)
    additional        = try(var.tags.additional, {})
  }

  overrides = {
    locations = {
      for k, v in try(var.overrides.locations, {}) :
      lower(trimspace(k)) => upper(trimspace(v))
    }
    environments = {
      for k, v in try(var.overrides.environments, {}) :
      lower(trimspace(k)) => trimspace(v)
    }
    short_environments = {
      for k, v in try(var.overrides.short_environments, {}) :
      lower(trimspace(k)) => upper(trimspace(v))
    }
  }

  label_order_source = length(local.options.label_order) > 0 ? local.options.label_order : local.defaults.label_order
  delimiter          = coalesce(local.options.delimiter, local.defaults.delimiter)
  regex_replace_chars = coalesce(local.options.regex_replace_chars, local.defaults.regex_replace_chars)

  prefix               = upper(trimspace(try(var.naming.prefix, "RG")))
  location             = trimspace(var.naming.location)
  namespace            = replace(trimspace(var.naming.namespace), local.regex_replace_chars, local.defaults.replacement)
  purpose              = replace(trimspace(var.naming.purpose), local.regex_replace_chars, local.defaults.replacement)
  attributes           = [for attribute in try(var.naming.attributes, []) : replace(trimspace(attribute), local.regex_replace_chars, local.defaults.replacement)]
  environment          = trimspace(var.naming.environment)
  environment_instance = try(var.naming.environment_instance, 0)

  label_order = [
    for label in local.label_order_source :
    lower(label)
  ]

  is_global_location = lower(local.location) == "global"
  include_location   = (local.options.include_global_location && local.is_global_location) || !local.is_global_location

  user_tags = {
    for k, v in local.tags_config.additional :
    title(replace(trimspace(k), local.regex_replace_chars, local.defaults.replacement)) => trimspace(v)
    if length(trimspace(k)) > 0 && length(trimspace(v)) > 0
  }

  tags = local.user_tags

  location_map = merge(
    module.common.locations,
    local.overrides.locations
  )

  environment_map_source = merge(
    module.common.environments,
    local.overrides.environments
  )

  short_environment_map_source = merge(
    module.common.short_environments,
    local.overrides.short_environments
  )

  environment_map = local.options.use_short_environment ? local.short_environment_map_source : local.environment_map_source

  mapped_location    = lookup(local.location_map, lower(local.location), null)
  mapped_environment = lookup(local.environment_map, lower(local.environment), null)

  padded_environment_instance = local.environment_instance == 0 ? "" : local.environment_instance

  name_context = {
    prefix               = local.prefix
    location             = local.include_location ? coalesce(local.mapped_location, "") : ""
    namespace            = local.namespace
    purpose              = local.purpose
    attributes           = join(local.delimiter, local.attributes)
    environment          = local.options.include_environment ? coalesce(local.mapped_environment, "") : ""
    environment_instance = local.padded_environment_instance
  }

  label_order_final = [
    for label in local.label_order : label
  ]

  labels = [
    for l in local.label_order_final :
    local.options.standardize ? upper(tostring(local.name_context[l])) : tostring(local.name_context[l])
    if length(tostring(local.name_context[l])) > 0
  ]

  resource_group_name = join(local.delimiter, local.labels)

  tags_context = {
    namespace              = local.namespace
    purpose                = local.purpose
    environment            = local.environment
    "EnvironmentInstance" = local.environment_instance
    location               = local.mapped_location
  }

  generated_tags = {
    for t in keys(local.tags_context) :
    title(t) => tostring(local.tags_context[t])
    if(length(tostring(local.tags_context[t])) > 0 && local.tags_config.include_generated)
  }

  resource_tags = merge(module.common.base_tags, local.generated_tags, local.tags)
}
