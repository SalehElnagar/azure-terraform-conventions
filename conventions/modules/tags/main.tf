locals {

  defaults = {
    regex_replace_chars = "/[^a-zA-Z0-9-]/"
    replacement         = ""
  }

  sanitized_namespace   = replace(trimspace(var.metadata.namespace), local.defaults.regex_replace_chars, local.defaults.replacement)
  sanitized_application = replace(trimspace(var.metadata.application), local.defaults.regex_replace_chars, local.defaults.replacement)
  sanitized_environment = trimspace(var.metadata.environment)

  tags_context = {
    Provisioner = "Terraform"
    Namespace   = local.sanitized_namespace
    Application = local.sanitized_application
    Environment = local.sanitized_environment
  }

  generated_tags = {
    for t, v in local.tags_context :
    t => tostring(v)
    if length(tostring(v)) > 0
  }

  user_tags = {
    for k, v in try(var.metadata.additional, {}) :
    title(replace(trimspace(k), local.defaults.regex_replace_chars, local.defaults.replacement)) => trimspace(v)
    if length(trimspace(k)) > 0 && length(trimspace(v)) > 0
  }

  tags = merge(module.common.base_tags, local.generated_tags, local.user_tags)

}

