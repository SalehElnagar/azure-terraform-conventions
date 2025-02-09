# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  description = "Azure location in condensed form, e.g. 'Switzerland north'"
}

variable "namespace" {
  description = "Group, sub-organization, technical group or project responsible, e.g. 'AircraftIT', 'DistApps', 'CoreServices', 'SAP', 'PLM'"
  default = "Topaz"
}

variable "purpose" {
  description = "Resource Group purpose or name. Used to differentiate from other Resource Groups."
  default = "NAT"
}

variable "application" {
  description = "This is the application/purpose of the resource."
  default = "Core"
}

variable "environment" {
  description = "Environment, e.g. 'production', 'quality', 'development', 'test', 'stage', 'nonproduction'"
}

variable "cost_center" {
  description = "The department used for billing. Format: A000 - AAAAAAAAAAAAAA"
  default = "Topaz"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "attributes" {
  type        = list(string)
  description = "Additional attributes for the Resource Group. Used to differentiate from other resource groups."
  default     = []
}

variable "public_ip_prefix_length" {
  type        = number
  description = "The CIDR prefix for IP allocation. Defaults to 2 addresses (/31)."
  default     = 31
}

variable "zones" {
  type        = list(number)
  description = "A list of zones to allocate the network resources in."
  default     = []
}

variable "idle_timeout_in_minutes" {
  type        = number
  description = "The idle timeout which should be used for the NAT Gateway."
  default     = null
}

variable "creator" {
  description = "The person or process who created this resource."
  default     = ""
}

variable "support_team" {
  description = "The IT team responsible for this resource."
  default     = ""
}

variable "role" {
  description = "This is the application/purpose of the resource. If multiple values are needed, separate with a comma ','"
  default     = ""
}

variable "standardize_resource_group" {
  type        = bool
  description = "Removes invalid characters and sets to uppercase. Set to false to prevent standardization."
  default     = false
}

variable "standardize_resources" {
  type        = bool
  description = "Removes invalid characters and sets to lowercase. Set to false to prevent standardization."
  default     = true
}

variable "include_environment" {
  type        = bool
  description = "Include the environment to the resource names."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "The list of additional tags for the resources."
  default     = {}
}
