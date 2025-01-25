# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  type        = string
  description = "Azure location in condensed form, e.g. 'Switzerland north'"
}

variable "namespace" {
  description = "Group, sub-organization, or project responsible, e.g. 'AircraftIT', 'DistApps', 'CoreServices', 'ADSAP', 'PLM'"
  default     = "Topaz"
}

variable "application" {
  description = "This is the application/purpose of the resource."
  default     = "Core"
}

variable "environment" {
  description = "Environment, e.g. 'production', 'quality', 'development', 'test', 'stage', 'nonproduction'"
}

variable "purpose" {
  description = "Deployment purpose or name. Used to differentiate from other resources."
  default     = "ACR"
}

variable "container_registry_purpose" {
  description = "Container Registry purpose or name. Used to differentiate from other Container Registries."
  default     = "Repository"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "resource_group_attributes" {
  type        = list(string)
  description = "Additional attributes for the Resource Group. Used to differentiate from other resource groups."
  default     = []
}

variable "container_registry_attributes" {
  type        = list(string)
  description = "Additional attributes for the Container Registry. Used to differentiate from other Container Registries."
  default     = []
}

variable "container_sku" {
  type        = string
  description = "The Container Registry sku. Accepted values are 'Basic', 'Standard', and 'Premium'."
  default     = "Standard"
}

variable "container_admin_enabled" {
  type        = bool
  description = "Specifies whether the admin user is enabled."
  default     = true
}

variable "container_georeplications" {
  type        = list(string)
  description = "A list of Azure locations where the container registry should be geo-replicated."
  default     = []

  validation {
    condition = var.container_georeplications != null
    error_message = "The container_georeplications variable can not be null."
  }
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
  description = "Additional tags to merge with generated tags."
  default     = {}
}
