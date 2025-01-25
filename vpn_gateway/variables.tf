# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  description = "Azure location in condensed form, e.g. 'Switzerland north'"
  default = "Switzerland north"
}
variable "resource_group_name" {
  description = "Group of the virtual network"
  default = "RG-SWN-Topaz-VNet-Stg"
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
  default = "VPN"
}

variable "environment" {
  description = "Environment, e.g. 'production', 'quality', 'development', 'test', 'stage', 'nonproduction'"
  default = "stage"
}

variable "cost_center" {
  description = "The department used for billing. Format: A000 - AAAAAAAAAAAAAA"
  default = "Topaz"
}

variable "subnet_id" {
  type        = string
  description = "Transit gateway subnet id"
  default = "/subscriptions/4bd941bd-7347-46f3-a2a5-488e5d75128f/resourceGroups/RG-SWN-Topaz-VNet-Stg/providers/Microsoft.Network/virtualNetworks/vn-swn-topaz-vnet-stg/subnets/GatewaySubnet"
}
variable "public_ip" {
  default = "pip-swn-vpn_gateway"
}
variable "local_network_gateway_name" {
  default = "lng-swn-vpn-gateway"
}
variable "virtual_network_gateway_connection_name" {
  default = "ips-swn-vpn-gateway"
}
variable "vpn_gateway_name" {
  default = "gw-swn-topaz-vpn-gateway"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------


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
