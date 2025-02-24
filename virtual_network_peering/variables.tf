# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
variable "local_virtual_network_name" {
  type        = string
  description = "The name of the local virtual network."
  default     = "vn-swn-topaz-vnet-dev"
}

variable "local_resource_group_name" {
  type        = string
  description = "The name of the local resource group."
  default     = "RG-SWN-Topaz-VNet-Dev"
}

variable "remote_virtual_network_name" {
  type        = string
  description = "The name of the remote virtual network."
  default     = "vn-swn-topaz-vnet-stg"
}

variable "remote_resource_group_name" {
  type        = string
  description = "The name of the remote resource group."
  default     = "RG-SWN-Topaz-VNet-Stg"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "local_allow_virtual_network_access" {
  description = "Controls if the VMs in the remote virtual network can access VMs in the local virtual network."
  type        = bool
  default     = false
}

variable "local_allow_forwarded_traffic" {
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed."
  type        = bool
  default     = false
}

variable "local_allow_gateway_transit" {
  description = "Controls gateway transit can be used in the remote virtual network’s link to the local virtual network."
  type        = bool
  default     = false
}

variable "local_use_remote_gateways" {
  description = "Controls if remote gateways can be used on the local virtual network."
  type        = bool
  default     = false
}

variable "local_peering_name" {
  description = "Custom name of the local vnet peering to create. Will be generated if left blank."
  type        = string
  default     = null
}

variable "remote_allow_virtual_network_access" {
  description = "Controls if the VMs in the remote virtual network can access VMs in the local virtual network."
  type        = bool
  default     = false
}

variable "remote_allow_forwarded_traffic" {
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed."
  type        = bool
  default     = false
}

variable "remote_allow_gateway_transit" {
  description = "Controls gateway transit can be used in the remote virtual network’s link to the local virtual network."
  type        = bool
  default     = false
}

variable "remote_use_remote_gateways" {
  description = "Controls if remote gateways can be used on the remote virtual network."
  type        = bool
  default     = false
}

variable "remote_peering_name" {
  description = "Custom name of the remote vnet peering to create. Will be generated if left blank."
  type        = string
  default     = null
}

variable "allow_virtual_dest_network_access" {
  description = "Option allow_virtual_network_access for the dest vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access"
  type        = bool
  default     = false
}

variable "allow_forwarded_dest_traffic" {
  description = "Option allow_forwarded_traffic for the dest vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic"
  type        = bool
  default     = false
}

variable "allow_gateway_dest_transit" {
  description = "Option allow_gateway_transit for the dest vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit"
  type        = bool
  default     = false
}

variable "use_remote_dest_gateway" {
  description = "Option use_remote_gateway for the dest vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = false
}

variable "custom_peering_dest_name" {
  description = "Custom name of the vnet peerings to create"
  type        = string
  default     = ""
}