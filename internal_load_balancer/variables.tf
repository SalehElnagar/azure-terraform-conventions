# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "The name of the load balancer."
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
  default     = "lb"
}

variable "attributes" {
  type        = list(string)
  description = "Additional name attributes for conventions-based naming."
  default     = []
}

variable "location" {
  type        = string
  description = "The location of the load balancer. Usually set to the resource group's location."
}


variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for the load balancer."
}

variable "default_subnet_id" { 
  type        = string
  description = "The subnet id where the load balancer frontend is deployed. Can override in each frontend configuration block."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "sku" {
  type        = string
  description = "The Azure load balancer networking sku. Accepted values are 'Basic' and 'Standard'."
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "The network sku must be Basic or Standard."
  }
}

variable "zones" {
  type        = list(number)
  description = "A list of availability zones where the Load Balancer's IP should be created."
  default     = null
}

variable "default_private_ip_address_allocation" {
  type        = string
  description = "Frontend ip allocation type (Static or Dynamic)."
  default     = "Dynamic"
}

variable "default_frontend_name" {
  type        = string
  description = "Specifies the name of the frontend ip configuration."
  default     = "LoadBalancerFrontEnd"
}

variable "default_frontend_private_ip_address" {
  type        = string
  description = "Private ip address to assign to frontend. Required when `default_private_ip_allocation_method` is `Static`."
  default     = null
}

variable "frontend_ip_configurations" {
  type        = list
  description = "A list of frontend ip configurations. Conflicts with default frontend variables."
  default     = null
}

variable "backend_address_pool_names" {
  type        = list(string)
  description = "The name of the backend address pools."
  default     = null
}

variable "probes" {
  type        = list
  description = "A list of load balancer probes."
  default     = []
}

variable "default_probe_interval_in_seconds" {
  type        = number
  description = "The interval in seconds between probe health attempts."
  default     = 15
}

variable "default_probe_number_of_probes" {
  type        = number
  description = "The number of failed probe attempts after which the backend endpoint is removed from rotation."
  default     = 2
}

variable "rules" {
  type        = list
  description = "The list of load balancer rules."
  default     = []
}

variable "default_rule_idle_timeout_in_minutes" {
  type = number
  description = "Specifies the timeout for the Tcp idle connection. Only used when a rule protocol is set to 'Tcp'."
  default = 4
}

variable "tags" {
  type        = map(any)
  description = "Any tags"
  default     = {}
}
