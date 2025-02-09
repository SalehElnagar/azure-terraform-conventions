locals {

  defaults = {

  }

  name                = coalesce(var.name, try(module.application_gateway_name.name, var.name))
  location            = var.location
  resource_group_name = data.azurerm_resource_group.application_gateway.name

  create_user_identity = var.create_user_identity || length(var.key_vault_ids) > 0

  sku = var.sku

  enable_autoscale        = var.autoscale_min_capacity != null && var.autoscale_max_capacity != null
  capacity                = var.capacity
  autoscale_min_capacity  = var.autoscale_min_capacity
  autoscale_max_capacity  = var.autoscale_max_capacity

  enable_http2 = var.enable_http2

  firewall_policy_id        = var.firewall_policy_id
  enable_waf                = var.enable_waf
  waf_rule_set_version      = var.waf_rule_set_version //3.1
  waf_firewall_mode         = var.waf_firewall_mode
  waf_file_upload_limit_mb  = 100 //The File Upload Limit in MB.
  max_request_body_size_kb  = 128 //The Maximum Request Body Size in KB. Accepted values are in the range 1KB to 128KB. Defaults to 128KB.
  request_body_check        = true //Is Request Body Inspection enabled? Defaults to true.

  waf_disabled_rule_groups  = var.waf_disabled_rule_groups
  waf_exclusions            = var.waf_exclusions

  enable_private_frontend = var.private_ip_address != null ? true : false  // replace with try 
  private_ip_address      = var.private_ip_address

  frontend_port_settings  = var.frontend_port_settings
  backend_address_pools   = var.backend_address_pools
  backend_http_settings   = var.backend_http_settings
  http_listeners          = var.http_listeners
  probes                  = var.probes
  request_routing_rules   = var.request_routing_rules
  url_path_maps           = var.url_path_maps
  rewrite_rule_sets       = var.rewrite_rule_sets
  redirect_configurations = var.redirect_configurations

  ssl_policy_name             = var.ssl_policy_name
  ssl_certificates            = var.ssl_certificates
  trusted_root_certificates   = var.trusted_root_certificates   
  key_vault_ids               = var.key_vault_ids

  custom_error_configurations = var.custom_error_configurations

  tags = merge(try(module.tags.tags, {}), try(var.tags, {}))
}
