
# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  type        = string
  description = "The name of the Application Gateway."
}

variable "namespace" {
  type        = string
  description = "Namespace or owning group for conventions-based naming/tags."
  default     = "example"
}

variable "application" {
  type        = string
  description = "Application identifier for tag generation."
  default     = "network"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., development, quality, production)."
  default     = "development"
}

variable "purpose" {
  type        = string
  description = "Purpose label used in conventions-based naming."
  default     = "application-gateway"
}

variable "attributes" {
  type        = list(string)
  description = "Additional name attributes for conventions-based naming."
  default     = []
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for Application Gateway."
}

variable "location" {
  type        = string
  description = "Resource group for Application Gateway."
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "The resource group name where the virtual network resides."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network."
}

variable "virtual_network_subnet_name" {
  type        = string
  description = "The name of the Application Gateway subnet."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "create_user_identity" {
  type        = bool 
  description = "Creates a user managed identity for the Application Gateway."
  default     = false
}

variable "zones" {
  type        = list(string)
  description = "Application Gateway availablity zones."
  default     = null //["1", "2", "3"]
}

variable "sku" {
  type        = string
  description = "Application Gateway SKU."
  default     = "Standard_v2"

  validation {
    condition     = contains(["Standard_v2", "WAF_v2"], var.sku)
    error_message = "The sku must be 'Standard_v2' or 'WAF_v2'."
  }
}

variable "capacity" {
  type        = number
  description = "The capacity of the SKU to use for this Application Gateway."
  default     = 1

  validation {
    condition     = (var.capacity >= 1 && var.capacity <= 125)
    error_message = "The capacity must be between 1 and 125."
  }
}

variable "autoscale_min_capacity" {
  type        = number
  description = "Minimum capacity for autoscaling. Accepted values are in the range 0 to 100."
  default     = null

  validation {
    condition     = var.autoscale_min_capacity != null ? (var.autoscale_min_capacity >= 0 && var.autoscale_min_capacity <= 100) : true
    error_message = "The autoscale_min_capacity must be between 0 and 100."
  }
}

variable "autoscale_max_capacity" {
  type        = number
  description = "Maximum capacity for autoscaling. Accepted values are in the range 2 to 125."
  default     = null

  validation {
    condition     = var.autoscale_max_capacity != null ? (var.autoscale_max_capacity >= 2 && var.autoscale_max_capacity <= 125) : true
    error_message = "The autoscale_max_capacity must be between 2 and 125."
  }
}

variable "enable_waf" {
  type        = bool
  description = "Enable WAF if sku is set to WAF_v2."
  default     = true
}

variable "firewall_policy_id" {
  type        = string
  description = "The ID of the Web Application Firewall Policy."
  default     = null 
}

variable "waf_firewall_mode" {
  description = "Application Gateway WAF firewall mode."
  type        = string
  default     = "Detection"

  validation {
    condition     = contains(["Detection", "Prevention"], var.waf_firewall_mode)
    error_message = "The waf_firewall_mode must be 'Detection' or 'Prevention'."
  }
}

variable "waf_rule_set_version" {
  description = "Application Gateway WAF firewall mode."
  type        = string
  default     = "3.1"

  validation {
    condition     = contains(["2.2.9", "3.0", "3.1"], var.waf_rule_set_version)
    error_message = "The Version of the Rule Set used for this Web Application Firewall. Possible values are 2.2.9, 3.0, and 3.1."
  }
}

variable "waf_disabled_rule_groups" {
  description = "WAF rule groups to disable in the Application Gateway."
  type = list(object({
    rule_group_name = string
    rules           = list(string)
  }))
  default = []
}

variable "waf_exclusions" {
  description = "WAF exclusion settings."
  type        = list(map(string))
  default     = []
}

variable "enable_http2" {
  type        = bool
  description = "Enable HTTP2 on the Application Gateway."
  default     = false
}

variable "private_ip_address" {
  type        = string
  description = "Application Gateway Private IP address. When null, only a public frontend is created."
  default     = null
}

variable "frontend_port_settings" {
  description = "Application Gateway frontend ports. The key is the frontend port name and the value is the port itself."
  type        = map(number)
  default = {
    "http" = 80
  }

  validation {
    condition     = can(length(var.frontend_port_settings) > 0)
    error_message = "The frontend_port_settings must not be null or an empty map."
  }
}

variable "backend_address_pools" {
  description = "Application Gateway backend address pools."
  type        = map(any)
  default = {
    "default" = {
      fqdns         = null // list of fqdns
      ip_addresses  = null // list of ip addresses
    }
  }

  validation {
    condition     = can(length(var.backend_address_pools) > 0)
    error_message = "The backend_address_pools must not be null or an empty map."
  }
}

variable "backend_http_settings" {
  description = "Application Gateway backend address pools."
  type        = map(any)
  default = {
    "default" = {
      path                  = "/"
      port                  = 80
      protocol              = "Http"
    }
  }

  validation {
    condition     = can(length(var.backend_http_settings) > 0)
    error_message = "The backend_http_settings must not be null or an empty map."
  }
}

variable "http_listeners" {
  type        = map(any)
  description = "Application Gateway HTTP listener configuration."
  default     = {
    "default" = {
      frontend_port_name              = "http"
      protocol                        = "Http"
    }
  }

  validation {
    condition     = can(length(var.http_listeners) > 0)
    error_message = "The http_listeners must not be null or an empty map."
  }
}

variable "probes" {
  type        = map(any)
  description = "Application Gateway HTTP probes."
  default     = {}

  validation {
    condition     = var.probes != null
    error_message = "The probes must not be null. An empty map is allowed."
  }
}

variable "request_routing_rules" {
  type        = map(any)
  description = "Application Gateway request routes."
  default     = {
    "default" = {
      rule_type                  = "Basic"
      http_listener_name         = "default"
      backend_address_pool_name  = "default"
      backend_http_settings_name = "default"
    }
  }

  validation {
    condition     = can(length(var.request_routing_rules) > 0)
    error_message = "The request_routing_rules must not be null or an empty map."
  }
}

variable "url_path_maps" {
  type        = map(any)
  description = "Application Gateway URL Path Maps."
  default     = {}

  validation {
    condition     = var.url_path_maps != null
    error_message = "The url_path_maps must not be null. An empty map is allowed."
  }
}

variable "rewrite_rule_sets" {
  type        = map(any)
  description = "Application Gateway rewrite rules."
  default     = {}

  validation {
    condition     = var.rewrite_rule_sets != null
    error_message = "The rewrite_rule_sets must not be null. An empty map is allowed."
  }
}

variable "redirect_configurations" {
  type        = map(any)
  description = "Application Gateway redirect configurations."
  default     = {}

  validation {
    condition     = var.redirect_configurations != null
    error_message = "The redirect_configurations must not be null. An empty map is allowed."
  }
}

# SSL Settings

variable "ssl_policy_name" {
  description = "SSL policy name to use with Application Gateway."
  type        = string
  default     = "AppGwSslPolicy20170401S"

  validation {
    condition     = contains(["AppGwSslPolicy20150501", "AppGwSslPolicy20170401", "AppGwSslPolicy20170401S"], var.ssl_policy_name)
    error_message = "The ssl_policy_name must be a valid predefined SSL Policy."
  }
}

variable "ssl_certificates" {
  description = "Application Gateway SSL certificates."
  type        = map(any)
  default = {}

  validation {
    condition     = var.ssl_certificates != null
    error_message = "The ssl_certificates must not be null. An empty map is allowed."
  }
}

# Trusted Root Certificates are V2 only.
variable "trusted_root_certificates" {
  description = "Application Gateway trusted root certificates."
  type        = map(string)
  default = {}

  validation {
    condition     = var.trusted_root_certificates != null
    error_message = "The trusted_root_certificates must not be null. An empty map is allowed."
  }
}

variable "key_vault_ids" {
  type        = list(string)
  description = "A list of key vault ids to use in the ssl_certificates block."
  default     = []
}

variable "custom_error_configurations" {
  description = "Application Gateway custom errors."
  type        = list(object({
    status_code           = string
    custom_error_page_url = string
  }))
  default = []

  validation {
    condition     = var.custom_error_configurations != null
    error_message = "The custom_error_configurations must not be null. An empty list is allowed."
  }
}

variable "tags" {
  type        = map(any)
  description = "Any tags"
  default     = {}
}
