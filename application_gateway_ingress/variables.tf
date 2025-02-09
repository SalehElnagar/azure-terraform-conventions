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
  description = "Group, sub-organization, or project responsible, e.g. 'AircraftIT', 'DistApps', 'CoreServices', 'ADSAP', 'PLM'"
  default     = "Topaz"
}

variable "application" {
  description = "This is the application/purpose of the resource."
  default      = "Core"
}

variable "environment" {
  description = "Environment, e.g. 'production', 'quality', 'development', 'test', 'stage', 'nonproduction'"
}

variable "cost_center" {
  description = "The department used for billing. Format: A000 - AAAAAAAAAAAAAA"
  default      = "Topaz"
}

variable "purpose" {
  description = "Deployment purpose or name. Used to differentiate from other resources."
  default     = "agic"
}


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "attributes" {
  type        = list(string)
  description = "Additional attributes for the resources. Used to differentiate from other resources."
  default     = []
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
