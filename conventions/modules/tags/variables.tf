# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "metadata" {
  description = "Structured metadata required to build the tag catalog."
  type = object({
    namespace   = string
    application = string
    environment = string
    additional  = optional(map(string), {})
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,60}$", trimspace(var.metadata.namespace)))
    error_message = "metadata.namespace must contain 2-60 alphanumeric or hyphen characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,60}$", trimspace(var.metadata.application)))
    error_message = "metadata.application must contain 2-60 alphanumeric or hyphen characters."
  }

  validation {
    condition     = length(trimspace(var.metadata.environment)) > 0
    error_message = "metadata.environment must not be blank."
  }

  validation {
    condition = alltrue([
      for k, v in try(var.metadata.additional, {}) :
      length(trimspace(k)) > 0 && length(trimspace(v)) > 0
    ])
    error_message = "metadata.additional keys and values must be non-empty strings."
  }
}
