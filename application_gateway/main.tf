locals {
  //backend_address_pool_name               = format("%s-beap", local.name)
  //frontend_port_name                      = format("%s-feport", local.name)
  frontend_ip_configuration_name          = "public-config" //format("%s-feip", local.name)
  private_frontend_ip_configuration_name  = "private-config" //format("%s-private-feip", local.name)
  // http_setting_name                       = format("%s-be-htst", local.name)
  //listener_name                           = format("%s-httplstn", local.name)
  // request_routing_rule_name               = format("%s-rqrt", local.name)
  // redirect_configuration_name             = format("%s-rdrcfg", local.name)

  default_ip_configuration_name = local.enable_private_frontend ? local.private_frontend_ip_configuration_name : local.frontend_ip_configuration_name
}

# https://medium.com/@denniszielke/securing-ingress-with-azureappgateway-and-egress-traffic-with-azurefirewall-for-azure-kubernetes-41af94051347
# https://www.starwindsoftware.com/blog/use-an-application-gateway-as-ingress-and-protect-your-aks-websites-with-a-waf
# https://docs.microsoft.com/en-us/azure/application-gateway/application-gateway-faq#how-do-i-use-application-gateway-v2-with-only-private-frontend-ip-address
resource "azurerm_public_ip" "application_gateway" {
  name                  = join("-", ["pip", lower(local.name)])
  resource_group_name   = data.azurerm_resource_group.application_gateway.name
  location              = data.azurerm_resource_group.application_gateway.location
  allocation_method     = "Static"
  sku                   = "Standard"

  tags                  = var.tags
}

resource "azurerm_application_gateway" "application_gateway" {
  name                = local.name
  resource_group_name = data.azurerm_resource_group.application_gateway.name
  location            = data.azurerm_resource_group.application_gateway.location
  zones               = var.zones

  dynamic "identity" {
    for_each = local.create_user_identity ? ["identity"] : []
    content {
      type = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.application_gateway[0].id]
    }
  }

  sku {
    name     = local.sku
    tier     = local.sku
    capacity = !local.enable_autoscale ? var.capacity : null
  }

  dynamic "autoscale_configuration" {
    for_each = local.enable_autoscale ? ["autoscale_configuration"] : []
    content {
      min_capacity = local.autoscale_min_capacity
      max_capacity = local.autoscale_max_capacity
    }
  }

  enable_http2  = local.enable_http2

  firewall_policy_id = local.firewall_policy_id

  dynamic "waf_configuration" {
    for_each = local.enable_waf && local.sku == "WAF_v2" ? ["waf_configuration"] : []
    content {
      enabled = local.enable_waf

      firewall_mode     = local.waf_firewall_mode
      rule_set_type     = "OWASP"
      rule_set_version  = local.waf_rule_set_version

      file_upload_limit_mb     = local.waf_file_upload_limit_mb 
      max_request_body_size_kb = local.max_request_body_size_kb
      request_body_check       = local.request_body_check

# rule_group_name - (Required) The rule group where specific rules should be disabled. Accepted values are: crs_20_protocol_violations, crs_21_protocol_anomalies, crs_23_request_limits, crs_30_http_policy, crs_35_bad_robots, crs_40_generic_attacks, crs_41_sql_injection_attacks, crs_41_xss_attacks, crs_42_tight_security, crs_45_trojans, General, REQUEST-911-METHOD-ENFORCEMENT, REQUEST-913-SCANNER-DETECTION, REQUEST-920-PROTOCOL-ENFORCEMENT, REQUEST-921-PROTOCOL-ATTACK, REQUEST-930-APPLICATION-ATTACK-LFI, REQUEST-931-APPLICATION-ATTACK-RFI, REQUEST-932-APPLICATION-ATTACK-RCE, REQUEST-933-APPLICATION-ATTACK-PHP, REQUEST-941-APPLICATION-ATTACK-XSS, REQUEST-942-APPLICATION-ATTACK-SQLI, REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION
# rules - (Optional) A list of rules which should be disabled in that group. Disables all rules in the specified group if rules is not specified.

      dynamic "disabled_rule_group" {
        for_each = local.waf_disabled_rule_groups
        content {
          rule_group_name = lookup(disabled_rule_group.value, "rule_group_name")
          rules           = lookup(disabled_rule_group.value, "rules")
        }
      }

// A exclusion block supports the following:
// match_variable - (Required) Match variable of the exclusion rule to exclude header, cookie or GET arguments. Possible values are RequestHeaderNames, RequestArgNames and RequestCookieNames
// selector_match_operator - (Optional) Operator which will be used to search in the variable content. Possible values are Equals, StartsWith, EndsWith, Contains. If empty will exclude all traffic on this match_variable
// selector - (Optional) String value which will be used for the filter operation. If empty will exclude all traffic on this match_variable

      dynamic "exclusion" {
        for_each = var.waf_exclusions
        content {
          match_variable          = lookup(exclusion.value, "match_variable")
          selector                = lookup(exclusion.value, "selector")
          selector_match_operator = lookup(exclusion.value, "selector_match_operator")
        }
      }
    }
  }

  # Public Frontend Configuration
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.application_gateway.id
  }

  # Private Frontend Configuration
  dynamic "frontend_ip_configuration" {
    for_each = local.enable_private_frontend ? ["frontend_ip_configuration"] : []
    content {
      name                          = local.private_frontend_ip_configuration_name
      private_ip_address_allocation = "Static"
      private_ip_address            = local.private_ip_address
      subnet_id                     = data.azurerm_subnet.application_gateway.id
    }
  }

  # Use only one gateway configuration for now
  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = data.azurerm_subnet.application_gateway.id
  }

  dynamic "frontend_port" {
    for_each = local.frontend_port_settings
    content {
      name = frontend_port.key
      port = frontend_port.value
    }
  }

  dynamic "backend_address_pool" {
    for_each = local.backend_address_pools
    content {
      name          = backend_address_pool.key
      fqdns         = lookup(backend_address_pool.value, "fqdns", null)
      ip_addresses  = lookup(backend_address_pool.value, "ip_addresses", null) 
    }
  }

  dynamic "backend_http_settings" {
    for_each = local.backend_http_settings
    content {
      name       = backend_http_settings.key
      port       = backend_http_settings.value.port
      protocol   = lookup(backend_http_settings.value, "protocol", "Http")
      path       = lookup(backend_http_settings.value, "path", null)
      probe_name = lookup(backend_http_settings.value, "probe_name", null)

      affinity_cookie_name                = lookup(backend_http_settings.value, "affinity_cookie_name", null)
      cookie_based_affinity               = lookup(backend_http_settings.value, "cookie_based_affinity", "Disabled")
      pick_host_name_from_backend_address = lookup(backend_http_settings.value, "pick_host_name_from_backend_address", false)
      host_name                           = lookup(backend_http_settings.value, "host_name", null)
      request_timeout                     = lookup(backend_http_settings.value, "request_timeout", 60)
      trusted_root_certificate_names      = lookup(backend_http_settings.value, "trusted_root_certificate_names", [])

      dynamic "authentication_certificate" {
        for_each = lookup(backend_http_settings.value, "authentication_certificate_names", [])
        content {
          name = authentication_certificate.value
        }
      }

      dynamic "connection_draining" {
        for_each = lookup(backend_http_settings.value, "connection_draining_timeout_sec", 0) > 0 ? ["connection_draining"] : []
        content {
          enabled           = true
          drain_timeout_sec = lookup(backend_http_settings.value, "connection_draining_timeout_sec", null)
        }
      }

    }
  }

  dynamic "http_listener" {
    for_each = local.http_listeners
    content {
      name                            = http_listener.key
      frontend_ip_configuration_name  = lookup(http_listener.value, "frontend_ip_configuration_name", local.default_ip_configuration_name)
      frontend_port_name              = http_listener.value.frontend_port_name 
      protocol                        = lookup(http_listener.value, "protocol", "Http")

      host_name   = lookup(http_listener.value, "host_name", null)
      host_names  = lookup(http_listener.value, "host_names", null) //The host_names and host_name are mutually exclusive and cannot both be set.
      require_sni = lookup(http_listener.value, "require_sni", false)

      ssl_certificate_name  = lookup(http_listener.value, "ssl_certificate_name", null)
      firewall_policy_id    = lookup(http_listener.value, "firewall_policy_id", null)

      dynamic "custom_error_configuration" {
        for_each = lookup(http_listener.value, "custom_errors", [])
        content {
          status_code           = custom_error_configuration.value.status_code //HttpStatus403 and HttpStatus502
          custom_error_page_url = custom_error_configuration.value.custom_error_page_url
        }
      }
    }
  }

  ## Probe
  dynamic "probe" {
    for_each = local.probes
    content {
      name                = probe.key
      path                = probe.value.path
      protocol            = lookup(probe.value, "protocol", "Http")
      port                = lookup(probe.value, "protocol", null)
      host                = lookup(probe.value, "host", null)
      interval            = lookup(probe.value, "interval", 15)
      unhealthy_threshold = lookup(probe.value, "unhealthy_threshold", 2)
      timeout             = lookup(probe.value, "timeout", 30)
      minimum_servers     = lookup(probe.value, "minimum_servers", 0)
      
      pick_host_name_from_backend_http_settings = lookup(probe.value, "pick_host_name_from_backend_http_settings", false)

      match {
        body        = lookup(probe.value, "match_body", "")
        status_code = lookup(probe.value, "match_status_code", ["200"])
      }
    }
  }

// backend_address_pool_name, backend_http_settings_name, redirect_configuration_name, and rewrite_rule_set_name are applicable only when rule_type is Basic.
  dynamic "request_routing_rule" {
    for_each = local.request_routing_rules
    content {
      name                        = request_routing_rule.key
      
      rule_type                   = lookup(request_routing_rule.value, "rule_type", "Basic")
      http_listener_name          = lookup(request_routing_rule.value, "http_listener_name", request_routing_rule.key)
      backend_address_pool_name   = lookup(request_routing_rule.value, "backend_address_pool_name", request_routing_rule.key)
      backend_http_settings_name  = lookup(request_routing_rule.value, "backend_http_settings_name", request_routing_rule.key)
      
      url_path_map_name           = lookup(request_routing_rule.value, "url_path_map_name", null)
      redirect_configuration_name = lookup(request_routing_rule.value, "redirect_configuration_name", null) //The Name of the URL Path Map which should be associated with this Routing Rule.
      rewrite_rule_set_name       = lookup(request_routing_rule.value, "rewrite_rule_set_name", null) 
    }
  }

  dynamic "url_path_map" {
    for_each = local.url_path_maps
    content {
      name                                = url_path_map.key
      default_backend_address_pool_name   = lookup(url_path_map.value, "default_backend_address_pool_name", null)   # Cannot be set if default_redirect_configuration_name is set.
      default_backend_http_settings_name  = lookup(url_path_map.value, "default_backend_http_settings_name", null)  # Cannot be set if default_redirect_configuration_name is set.
      default_redirect_configuration_name = lookup(url_path_map.value, "default_redirect_configuration_name", null) # Cannot be set if either default_backend_address_pool_name or default_backend_http_settings_name is set.
      default_rewrite_rule_set_name       = lookup(url_path_map.value, "default_rewrite_rule_set_name", null)
      
      dynamic "path_rule" {
        for_each = url_path_map.value.path_rules
        content {
          name                        = path_rule.key
          paths                       = path_rule.value.paths
          backend_address_pool_name   = lookup(path_rule.value, "backend_address_pool_name", null)    # Cannot be set if redirect_configuration_name is set.
          backend_http_settings_name  = lookup(path_rule.value, "backend_http_settings_name", null)   # Cannot be set if redirect_configuration_name is set.
          redirect_configuration_name = lookup(path_rule.value, "redirect_configuration_name", null)  # Cannot be set if either backend_address_pool_name or backend_http_settings_name is set.
          rewrite_rule_set_name       = lookup(path_rule.value, "rewrite_rule_set_name", null)
        }
      }
    }
  }

  dynamic "rewrite_rule_set" {
    for_each = local.rewrite_rule_sets
    content {
      name = rewrite_rule_set.key
      dynamic "rewrite_rule" {
        for_each = rewrite_rule_set.value
        content {
          name          = rewrite_rule.key
          rule_sequence = rewrite_rule.value.rule_sequence

          // TODO: dynamic block
          condition {
            variable    = rewrite_rule.value.condition_variable
            pattern     = rewrite_rule.value.condition_pattern
            ignore_case = lookup(rewrite_rule.value, "condition_ignore_case", false)
            negate      = lookup(rewrite_rule.value, "condition_negate", false)
          }

          // TODO: dynamic block
          request_header_configuration {
            header_name  = lookup(rewrite_rule.value, "request_header_name", null)
            header_value = lookup(rewrite_rule.value, "request_header_value", null)
          }

          // TODO: dynamic block
          response_header_configuration {
            header_name  = lookup(rewrite_rule.value, "response_header_name", null)
            header_value = lookup(rewrite_rule.value, "response_header_value", null)
          }
        }
      }
    }
  }

  dynamic "redirect_configuration" {
    for_each = var.redirect_configurations
    content {
      name                 = redirect_configuration.key
      redirect_type        = lookup(redirect_configuration.value, "redirect_type", "Permanent") # Permanent, Temporary, Found and SeeOther
      target_listener_name = lookup(redirect_configuration.value, "target_listener_name", null) # Cannot be set if target_url is set.
      target_url           = lookup(redirect_configuration.value, "target_url", null)           # Cannot be set if target_listener_name is set.
      include_path         = lookup(redirect_configuration.value, "include_path", false)
      include_query_string = lookup(redirect_configuration.value, "include_query_string", false)
    }
  }

  #################################################
  # SSL and Certificate Configuration
  #################################################

  ssl_policy {
    policy_type = "Predefined" // "Custom"
    policy_name = local.ssl_policy_name
  }

  dynamic "ssl_certificate" {
    for_each = local.ssl_certificates
    content {
      name                = ssl_certificate.key
      data                = lookup(ssl_certificate.value, "data", null)
      password            = lookup(ssl_certificate.value, "password", null)
      key_vault_secret_id = lookup(ssl_certificate.value, "key_vault_secret_id", null)
    }
  }

  dynamic "trusted_root_certificate" {
    for_each = local.trusted_root_certificates
    content {
      name = trusted_root_certificate.key
      data = trusted_root_certificate.value
    }
  }

  dynamic "custom_error_configuration" {
    for_each = local.custom_error_configurations
    content {
      status_code           = custom_error_configuration.value.status_code
      custom_error_page_url = custom_error_configuration.value.custom_error_page_url
    }
  }

}
