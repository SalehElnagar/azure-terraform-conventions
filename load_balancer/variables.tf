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

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for the load balancer."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
variable "type" {
  type        = string
  description = "The type of load balancer. Accepted values are 'Private' and 'Public'."
  default     = "Private"
}

variable "sku" {
  type        = string
  description = "The Azure load balancer networking sku. Accepted values are 'Basic' and 'Standard'."
  default     = "Basic"
}

variable "frontend_name" {
  type        = string
  description = "Specifies the name of the frontend ip configuration."
  default     = "LoadBalancerFrontEnd"
}

variable "private_ip_subnet_id" {
  type        = string
  description = "Frontend subnet id to use when in private mode."
  default     = null
}

variable "private_ip_allocation_method" {
  type        = string
  description = "Frontend ip allocation type (Static or Dynamic)."
  default     = "Dynamic"
}

variable "private_ip_address" {
  type        = string
  description = "Private ip address to assign to frontend. Use it with type = private."
  default     = null
}

variable "public_ip_name" {
  type        = string
  description = "Specifies the name of the public IP address. Required if type is set to 'Public'"
  default     = null
}

variable "public_ip_allocation_method" {
  type        = string
  description = "The type of load balancer. Accepted values are 'Dynamic' and 'Static'."
  default     = "Dynamic"
}

variable "backend_name" {
  type        = string
  description = "Specifies the name of the backend ip configuration."
  default     = "BackEndAddressPool"
}

variable "probes" {
  type        = list
  description = "A list of load balancer probes."
  default     = []
}

variable "probe_default_interval_in_seconds" {
  type        = number
  description = "The interval in seconds between probe health attempts."
  default     = 15
}

variable "probe_default_number_of_probes" {
  type        = number
  description = "The number of failed probe attempts after which the backend endpoint is removed from rotation."
  default     = 2
}

variable "rules" {
  type        = list
  description = "The list of load balancer rules."
  default     = []
}

variable "rule_default_idle_timeout_in_minutes" {
  type = number
  description = "Specifies the timeout for the Tcp idle connection. Only used when a rule protocol is set to 'Tcp'."
  default = 4
}

variable "outbound_rules" {
  type = list
  description = "The lost of load balancer outbound rules. Used when type = 'Public'"
  default = []
}

variable "tags" {
  type        = map(any)
  description = "Any tags"
  default     = {}
}
