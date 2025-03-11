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

variable "vmss_name_prefix" {
  type        = string
  description = "The prefix of the VMSS to create."
}

variable "vmss_user_name" {
  type        = string
  description = "The name of the admin user."
}

variable "vmss_ssh_key_data" {
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

variable "source_image_id" {
  type        = string
  description = "The Id of an Image which each Virtual Machine in this Scale Set should be based on."
  default     = null
}

variable "source_image_plan" {
  type        = object({
    name      = string
    product   = string
    publisher = string
  })
  description = "A plan block for marketplace images."
  default     = null
}

variable "instances" {
  type        = string
  description = "The number of instances to deploy."
  default     = 1
}

variable "overprovision" {
  type        = bool
  description = "Specifies whether the virtual machine scale set should be overprovisioned."
  default     = true
}

variable "sku" {
  type        = string
  description = "Specifies the size of the Virtual Machine Scale Set."
  default     = "Standard_F4"
}

variable "single_placement_group" {
  type        = bool
  description = "Specifies whether the scale set is limited to a single placement group with a maximum size of 100 virtual machines."
  default     = true
}

variable "zones" {
  type        = list(number)
  description = "A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in."
  default     = null
}

variable "zone_balance" {
  type        = bool
  description = "Strictly balance the virtual machines within the scale set across zones."
  default     = false
}

variable "proximity_placement_group_id" {
  type        = string
  description = "The Id of the Proximity Placement Group to which this Virtual Machine should be assigned."
  default     = null
}

variable "platform_fault_domain_count" {
  type        = number
  description = "Specifies the number of fault domains that are used by this Linux Virtual Machine Scale Set."
  default     = null
}

# ---------------------------------------------
# Disks 
# ---------------------------------------------

variable "os_disk_size_gb" {
  type        = string
  description = "Specifies the size of the managed OS disk to create."
  default     = null
}

variable "os_disk_storage_account_type" {
  type        = string
  description = "Specifies the type of managed disk to create. Possible values are either 'Standard_LRS', 'StandardSSD_LRS', 'Premium_LRS'."
  default     = "StandardSSD_LRS"

  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS"], var.os_disk_storage_account_type)
    error_message = "The OS disk storage account type is not valid."
  }
}

variable "os_disk_caching" {
  type        = string
  description = "The type of caching which should be used for the OS disk. Possible values are 'None', 'ReadOnly', and 'ReadWrite'"
  default     = "ReadWrite"

  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    error_message = "The OS disk caching is not valid."
  }
}

variable "data_disk_default_size_gb" {
  type        = number
  description = "Specifies the size of the data disk in gigabytes."
  default     = 32

  validation {
    condition     = var.data_disk_default_size_gb != null
    error_message = "The data disk default size must not be null."
  }
}

variable "data_disk_default_storage_account_type" {
  type        = string
  description = "Specifies the type of managed disk to create. Possible values are either 'Standard_LRS', 'StandardSSD_LRS', 'Premium_LRS' or 'UltraSSD_LRS'."
  default     = "StandardSSD_LRS"

  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "UltraSSD_LRS"], var.data_disk_default_storage_account_type)
    error_message = "The data disk storage account type is not valid."
  }
}

variable "data_disk_default_caching" {
  type        = string
  description = "Specifies the caching requirements for the Data Disk. Possible values include 'None', 'ReadOnly' and 'ReadWrite'."
  default     = "None"

  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.data_disk_default_caching)
    error_message = "The data disk caching is not valid."
  }
}

variable "data_disk_default_create_option" {
  type        = string
  description = "Specifies how the data disk should be created. Possible values are 'FromImage' and 'Empty'."
  default     = "Empty"

  validation {
    condition     = contains(["Empty", "FromImage"], var.data_disk_default_create_option)
    error_message = "The data disk create option is not valid."
  }
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

variable "disk_encryption_set_id" {
  type        = string
  description = "The Id of the Disk Encryption Set which should be used to encrypt all disks"
  default     = null
}

# ---------------------------------------------
# Network
# ---------------------------------------------

variable "dns_servers" {
  type        = list(string)
  description = "List of DNS servers IP addresses to use for the primary NIC, overrides the VNet-level server list."
  default     = []
}

variable "network_security_group_id" {
  type        = string
  description = "The Id of a Network Security Group which should be assigned to this Network Interface."
  default     = null
}

variable "enable_accelerated_networking" {
  type        = bool
  description = "Indicates if accelerated networking is set on the primary Network Interface."
  default     = false
}

variable "load_balancer_backend_address_pool_ids" {
  type        = list(string)
  description = "List of Load Balancer Backend Address Pool Ids."
  default     = []
}

variable "application_gateway_backend_address_pool_ids" {
  type        = list(string)
  description = "List of Application Gateway Backend Pool Ids."
  default     = []
}

variable "application_security_group_ids" {
  type        = list(string)
  description = "List of Application Security Group Ids for the primary NIC."
  default     = []
}

# ---------------------------------------------
# Health and Upgrades
# ---------------------------------------------

variable "upgrade_mode" {
  type        = string
  description = "Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances." 
  default     = "Manual"

  validation {
    condition     = contains(["Automatic", "Manual","Rolling"], var.upgrade_mode)
    error_message = "The upgrade_mode variable is not valid."
  }
}

variable "scale_in_policy" {
  type        = string
  description = "The scale-in policy rule that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled in." 
  default     = "Default"

  validation {
    condition     = contains(["Default", "NewestVM", "OldestVM"], var.scale_in_policy)
    error_message = "The scale_in_policy variable is not valid."
  }
}

variable "enable_automatic_os_upgrade" {
  type        = bool
  description = "Whether to set the automatic_os_upgrade block when the upgrade_mode is 'Automatic'."
  default     = true
}

# disable_automatic_rollback  = true  #- (Required) Should automatic rollbacks be disabled? Changing this forces a new resource to be created.
# enable_automatic_os_upgrade = true  # - (Required) Should OS Upgrades automatically be applied to Scale Set instances in a rolling fashion when a newer version of the OS Image becomes available? Changing this forces a new resource to be created.

variable "health_probe_id" {
  type        = string
  description = "The ID of a Load Balancer Probe which should be used to determine the health of an instance. This is Required and can only be specified when upgrade_mode is set to 'Automatic' or 'Rolling'."
  default     = null
}

variable "enable_automatic_instance_repair" {
  type        = bool
  description = "Whether to set the automatic_instance_repair block."
  default     = true
}

variable "max_batch_instance_percent" {
  type        = number
  description = "The maximum percent of total virtual machine instances that will be upgraded simultaneously by the rolling upgrade in one batch."
  default     = 21
}

variable "max_unhealthy_instance_percent" {
  type        = number
  description = "The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts."
  default     = 22
}

variable "max_unhealthy_upgraded_instance_percent" {
  type        = number
  description = "The maximum percentage of upgraded virtual machine instances that can be found to be in an unhealthy state."
  default     = 23
}

variable "pause_time_between_batches" {
  type        = string
  description = "The wait time between completing the update for all virtual machines in one batch and starting the next batch. The time duration should be specified in ISO 8601 format."
  default     = "PT30S"
}

# ---------------------------------------------
# Health Probe
# ---------------------------------------------
variable "enable_application_health_probe" {
  type        = bool
  description = "Whether to enable the Application Health Probe."
  default     = false
}

variable "application_health_probe" {
  type        = object({
    protocol      = string
    port          = number
    request_path  = string
  })
  description = "The probe information for the local application health extension."
  default     = null

  validation {
    condition     = var.application_health_probe != {}
    error_message = "The application health probe must not be empty."
  }
}

# ---------------------------------------------
# Identity
# ---------------------------------------------

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

variable "custom_data" {
  type        = string
  description = "The Base64-Encoded Custom Data which should be used for this Virtual Machine Scale Set."
  default     = null
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

variable "tags" {
  type        = map(any)
  description = "Any tags"
  default     = {}
}
