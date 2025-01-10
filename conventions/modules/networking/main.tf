locals {

  defaults = {
    label_order = ["location", "boundary","solution","environment_instance", "attributes", "environment"]
    delimiter   = "-"
    replacement = ""
    attributes  = [""]
    tags        = {}
  }

  network_security_group_prefix = "NSG"
  subnet_prefix                 = "SUB"
  route_table_prefix            = "RT"
  prefixes = [
    local.network_security_group_prefix,
    local.subnet_prefix,
    local.route_table_prefix
  ]

  enabled                 = var.enabled
  standardize             = var.standardize
  include_environment     = var.include_environment
  use_short_environment   = var.use_short_environment
  include_generated_tags  = var.include_generated_tags

  regex_replace_chars = var.regex_replace_chars

  environment_map = local.use_short_environment ? module.common.short_environments : module.common.environments
  mapped_environment = merge(
    local.environment_map,
    {
      "" = ""
    },
  )

  label_order = local.defaults.label_order
  delimiter   = var.delimiter != null ? var.delimiter : local.defaults.delimiter
  location    = module.common.locations[lower(var.location)]
  boundary    = local.network_boundaries[lower(var.boundary)]
  solution    = replace(var.solution, var.regex_replace_chars, local.defaults.replacement)
  attributes  = compact(distinct(concat(var.attributes, local.defaults.attributes)))
  environment = local.mapped_environment[lower(var.environment)]
  padded_environment_instance = var.environment_instance == 0 ? "" : var.environment_instance

  name_suffix_context = {
    location    = local.location,
    boundary    = local.boundary,
    solution    = local.solution,
    attributes  = replace(join(local.delimiter, local.attributes), local.regex_replace_chars, local.defaults.replacement)
    environment = local.include_environment ? local.environment : ""
    environment_instance  = local.padded_environment_instance
  }

  name_suffixes = [for l in local.label_order : local.name_suffix_context[l] if length(local.name_suffix_context[l]) > 0]

  resource_names = {
    for prefix in local.prefixes :
    prefix => join(local.delimiter, [for chunk in concat([prefix], local.name_suffixes) : local.standardize ? upper(chunk) : chunk])
  }

  network_security_group_name = local.resource_names[local.network_security_group_prefix]
  subnet_name                 = local.resource_names[local.subnet_prefix]
  route_table_name            = local.resource_names[local.route_table_prefix]

  # Generate tags (don't include tags with empty values)
  tags_context = {
    solution    = local.solution
    environment = var.environment
    "EnvironmentInstance"  = var.environment_instance
    location    = local.location
    attributes  = join(", ", local.attributes)
  }

  generated_tags = {
    for t in keys(local.tags_context) :
    title(t) => local.tags_context[t]
    if(length(tostring(local.tags_context[t])) > 0 && local.include_generated_tags)
  }

  tags = merge(module.common.base_tags, local.generated_tags, var.tags)

}