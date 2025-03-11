# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for the vm resources."
}

variable "location" {
  type        = string
  description = "The location of the VM. Usually set to the resource group's location."
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
  description = "The name of the subnet."
}

variable "namespace" {
  type        = string
  description = "Namespace or owning group for conventions-based naming/tags."
  default     = "example"
}

variable "application" {
  type        = string
  description = "Application identifier for tag generation."
  default     = "compute"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., development, quality, production)."
  default     = "development"
}

variable "attributes" {
  type        = list(string)
  description = "Additional name attributes for conventions-based naming."
  default     = []
}

variable "virtual_machine_name" {
  type        = string
  description = "The name of the VM to create."
}
variable "virtual_machine_purpose" {
  type        = string
  description = "The purpose of the VM."
}

variable "virtual_machine_user_name" {
  type        = string
  description = "The name of the admin user."
}

variable "virtual_machine_ssh_key_data" {
  type        = list(string)
  description = "The SSH keys set for the admin user."
}

variable "source_image_publisher" {
  type        = string
  description = "Specifies the OS source image publisher."
}

variable "source_image_offer" {
  type        = string
  description = "Specifies the OS source image offer."
}

variable "source_image_sku" {
  type        = string
  description = "Specifies the OS source image SKU."
}

variable "source_image_version" {
  type        = string
  description = "Specifies the OS source image version."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "source_image_plan" {
  type        = object({
    name      = string
    product   = string
    publisher = string
  })
  description = "A plan block for marketplace images."
  default     = null
}

variable "virtual_machine_size" {
  type        = string
  description = "Specifies the size of the Virtual Machine."
  default     = null
}

variable "source_image_id" {
  type        = string
  description = "Specifies the OS source image id."
  default     = null

}

variable "os_disk_size_gb" {
  type        = string
  description = "Specifies the size of the managed OS disk to create."
  default     = null
}

variable "os_disk_storage_account_type" {
  type        = string
  description = "Specifies the type of managed disk to create. Possible values are either 'Standard_LRS', 'StandardSSD_LRS', 'Premium_LRS' or 'UltraSSD_LRS'."
  default     = null
}

variable "os_disk_caching" {
  type        = string
  description = "The type of caching which should be used for the OS disk. Possible values are 'None', 'ReadOnly', and 'ReadWrite'"
  default     = null
}

variable "proximity_placement_group_id" {
  type        = string
  description = "The Id of the Proximity Placement Group to which this Virtual Machine should be assigned."
  default     = null
}

variable "availability_set_id" {
  type        = string
  description = "The id of the availability set for the VM. Conflicts with 'availability_zone'."
  default     = null
}

variable "availability_zone" {
  type        = number
  description = "The zone number where to deploy the VM. Conflicts with 'availability_set_id'."
  default     = null
}

variable "private_ip_allocation_method" {
  type        = string
  description = "The allocation method of the private IP address. Allowed values are 'Static' and 'Dynamic'."
  default     = null
}

variable "private_ip_address" {
  type        = string
  description = "If supplied, overrides the private IP for the NIC."
  default     = null
}

variable "enable_accelerated_networking" {
  type        = bool
  description = "Indicates if accelerated networking is set on the primary Network Interface."
  default     = false
}

variable "load_balancer_backend_address_pools_ids" {
  type        = list(string)
  description = "List of Load Balancer Backend Address Pool Ids."
  default     = []
}

variable "load_balancer_inbound_nat_rules_ids" {
  type        = list(string)
  description = "List of Load Balancer Inbound Nat Rules Ids."
  default     = []
}

variable "application_security_group_ids" {
  type        = list(string)
  description = "List of Application Security Group Ids for the primary NIC."
  default     = []
}

variable "public_ip_create" {
  type        = bool
  description = "Whether to attach a public ip to the VM NIC."
  default     = false
}

variable "public_ip_sku" {
  type        = string
  description = "The SKU of the public IP address."
  default     = null
}

variable "public_ip_allocation_method" {
  type        = string
  description = "The allocation method of the public IP address."
  default     = null
}

variable "dns_servers" {
  type        = list(string)
  description = "List of DNS servers IP addresses to use for the primary NIC, overrides the VNet-level server list"
  default     = []
}

variable "data_disks" {
  type = list(object({
    name_part                 = string
    disk_size_gb              = number
    storage_account_type      = string
    caching                   = string
    create_option             = string
    lun                       = number
    write_accelerator_enabled = bool
  }))
  description = "A list of data disks to create."
  default     = []
}

variable "data_disk_default_size_gb" {
  type        = number
  description = "Specifies the size of the data disk in gigabytes."
  default     = null
}

variable "data_disk_default_storage_account_type" {
  type        = string
  description = "Specifies the type of managed disk to create. Possible values are either 'Standard_LRS', 'StandardSSD_LRS', 'Premium_LRS' or 'UltraSSD_LRS'."
  default     = null
}

variable "data_disk_default_caching" {
  type        = string
  description = "Specifies the caching requirements for the Data Disk. Possible values include 'None', 'ReadOnly' and 'ReadWrite'."
  default     = null
}

variable "data_disk_default_create_option" {
  type        = string
  description = "Specifies how the data disk should be created. Possible values are 'Attach', 'FromImage' and 'Empty'."
  default     = null
}

variable "enable_system_identity" {
  type        = bool
  description = "Assign a system managed identity to the VM."
  default     = false
}

variable "system_identity_role_assignments" {
  type        = list(string)
  description = "A list of role assignment names for the system generated identity applied at the resource group scope."
  default     = []
}

variable "user_identity_ids" {
  type        = list(string)
  description = "List Resource Ids for User Managed Identites to assign to the VM."
  default     = []
}

variable "custom_script_enable" {
  type        = bool
  description = "Enable running a custom script on the VM."
  default     = false
}

variable "custom_script_file_uris" {
  type        = list(string)
  description = "The file URIs to be passed to the VM custom script extension."
  default     = []
}

variable "custom_script_command" {
  type        = string
  description = "The commands to be passed to the VM custom script extension."
  default     = ""
}

variable "disk_encryption_set_id" {
  type        = string
  description = "The Id of the Disk Encryption Set which should be used to encrypt all disks"
  default     = null
}

variable "certificates" {
  type        = object({
    key_vault_id  = string
    secret_ids    = list(string)
  })
  description = "A list of key vault certificates to upload to the virtual machine."
  default     = null
}

variable "azure_monitor_agent_settings" {
  type = object({
    workspace_id            = string
    workspace_key           = string
    enable_dependency_agent = bool
  })
  description = "Log Analytics settings for the Azure Monitor Agent."
  default     = null
}

variable "recovery_services_protection_policy" {
  type = object({
    name                = string
    recovery_vault_name = string
    resource_group_name = string
  })
  description = "An existing Recovery Services Protection Policy to backup the VM."
  default     = null
}

variable "tags" {
  type        = map(any)
  description = "Any tags"
  default     = {}
}
