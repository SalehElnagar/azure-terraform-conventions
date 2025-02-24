# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "The name of the Azure Firewall."
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
  default     = "firewall"
}

variable "attributes" {
  type        = list(string)
  description = "Additional name attributes for conventions-based naming."
  default     = []
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for the Azure Firewall."
}

variable "subnet_id" {
  type        = string
  description = "The subnet id of the AzureFirewallSubnet."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  type        = string
  description = "The Azure location of Azure Firewall. If not supplied, will use Resource Group location."
  default     = null
}

variable "public_ip_name" {
  type        = string
  description = "The name of the Public IP for the Azure Firewall. Will use the Azure Firewall name if not supplied."
  default     = null
}

variable "firewall_policy_id" {
  type        = string
  description = "The Id of the Firewall Policy applied to this Firewall."
  default     = null
}

variable "dns_servers" {
  type        = list(string)
  description = "A list of DNS servers that the Azure Firewall will direct DNS traffic to the for name resolution."
  default     = []
}

variable "sku_tier" {
  type        = string
  description = "Sku tier of the Firewall. Possible values are 'Premium' and 'Standard'."
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.sku_tier)
    error_message = "The sku_tier variable can only be 'Premium' and 'Standard'."
  }
}

variable "threat_intel_mode" {
  type        = string
  description = "The threat intelligence mode of the Azure Firewall policy."
  default     = "Deny"

  validation {
    condition     = contains(["Alert", "Deny", "Off"], var.threat_intel_mode)
    error_message = "The threat_intel_mode  variable can only be 'Alert', 'Deny' or 'Off'."
  }
}

variable "zones" {
  type        = list(string)
  description = "Azure Firewall availablity zones."
  default     = null
}

variable "application_rule_collection" {
  type = list(object({
    name      = string
    priority  = number
    action    = string
    rules     = map(object({
      description           = string
      source_addresses      = list(string)
      fqdn_tags             = list(string)
      target_fqdns          = list(string)
      protocols             = list(object({
        port = string
        type = string
      }))
    }))
  }))
  description = "List of Application Rule Collections and their rules created for this Azure Firewall."
  default     = []
}

variable "network_rule_collection" {
  type = list(object({
    name      = string
    priority  = number
    action    = string
    rules     = map(object({
      description           = string
      source_addresses      = list(string)
      destination_addresses = list(string)
      destination_fqdns     = list(string)
      destination_ports     = list(string)
      protocols             = list(string)
    }))
  }))
  description = "List of Network Rule Collections and their rules created for this Azure Firewall."
  default     = []
}

variable "nat_rule_collection" {
  type = list(object({
    name      = string
    priority  = number
    action    = string
    rules     = map(object({
      description           = string
      //destination_addresses = list(string)
      destination_ports     = list(string)
      protocols             = list(string)
      source_addresses      = list(string)
      translated_address    = string
      translated_port       = string
    }))
  }))
  description = "List of NAT Rule Collections and their rules created for this Azure Firewall."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Any tags"
  default     = {}
}
