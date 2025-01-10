# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  description = "Azure region in condensed form, e.g. 'useast2', 'uscentral'."
}

variable "role" {
  description = "The type of VM. Allowed values: 'Workstation', 'Server'."
}

variable "name" {
  description = "Solution name."
}

variable "environment" {
  description = "Application environment. Allowed values: 'Development', 'Production', 'Quality', 'Test', 'Sandbox', 'NonProduction', 'PreProduction'."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "environment_instance" {
  type        = number
  description = "Environment instance. Used to differentiate between environments of the same type."
  default     = 0
}

variable "instance" {
  description = "Application instance."
  default     = 0
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `{'BusinessUnit','XYZ'}`."
}

