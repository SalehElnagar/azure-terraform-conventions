# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  description = "Azure location in condensed form, e.g. 'Switzerland north'"
}
variable "storageName" {
  description = "Azure location in condensed form, e.g. 'Switzerland north'"
}
variable "key" {
  description = "Azure location in condensed form, e.g. 'Switzerland north'"
}

variable "namespace" {
  description = "Group, sub-organization, technical group or project responsible, e.g. 'AircraftIT', 'DistApps', 'CoreServices', 'SAP', 'PLM'"
  default     = "Topaz"
}

variable "application" {
  description = "This is the application/purpose of the resource."
  default = "Core"
}

variable "resource_group_purpose" {
  description = "Resource Group purpose or name. Used to differentiate from other Resource Groups."
  default = "VNet"
}

variable "environment" {
  description = "Environment, e.g. 'production', 'quality', 'development', 'test', 'stage', 'nonproduction'"
}

variable "cost_center" {
  description = "The department used for billing. Format: A000 - AAAAAAAAAAAAAA"
  default = "Topaz"
}

variable "virtual_network_address_space" {
  type        = list(string)
  description = "Address space to use for the virtual network."
  default = ["10.40.0.0/22", "10.50.0.0/19"]
}

variable "region_address_space" {
  type        = string
  description = "The address space of the entire region. Used for firewall rules."
  default = "10.0.0.0/8"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------


variable "virtual_network_dns_servers" {
  type        = list(string)
  description = "List of DNS servers IP addresses to use for the virtual network."
  default     = null
}

variable "resource_group_attributes" {
  type        = list(string)
  description = "Additional attributes for the Resource Group. Used to differentiate from other resource groups."
  default     = []
}

variable "storage_account_attributes" {
  type        = list(string)
  description = "Additional attributes for the storage account. Used to differentiate from other storage accounts."
  default     = []
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
