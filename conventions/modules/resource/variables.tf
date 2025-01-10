# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "naming" {
  description = "Object describing the core resource identity inputs."
  type = object({
    prefix               = string
    location             = string
    namespace            = string
    purpose              = string
    environment          = string
    environment_instance = optional(number, 0)
    attributes           = optional(list(string), [])
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{1,12}$", trimspace(var.naming.prefix)))
    error_message = "naming.prefix must be 1-12 alphanumeric characters to satisfy Azure naming guidance."
  }

  validation {
    condition     = length(trimspace(var.naming.location)) > 0
    error_message = "naming.location must not be blank."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,60}$", trimspace(var.naming.namespace)))
    error_message = "naming.namespace must contain 2-60 alphanumeric or hyphen characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,60}$", trimspace(var.naming.purpose)))
    error_message = "naming.purpose must contain 2-60 alphanumeric or hyphen characters."
  }

  validation {
    condition     = length(trimspace(var.naming.environment)) > 0
    error_message = "naming.environment must not be blank."
  }

  validation {
    condition = alltrue([
      for attribute in try(var.naming.attributes, []) :
      can(regex("^[a-zA-Z0-9-]{1,30}$", trimspace(attribute)))
    ])
    error_message = "Each naming.attributes entry must be 1-30 alphanumeric or hyphen characters."
  }

  validation {
    condition     = try(var.naming.environment_instance, 0) >= 0 && try(var.naming.environment_instance, 0) <= 99
    error_message = "naming.environment_instance must be a positive integer less than 100."
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "options" {
  description = "Optional fine-grained controls for label ordering and formatting."
  type = object({
    standardize             = optional(bool, true)
    delimiter               = optional(string)
    regex_replace_chars     = optional(string)
    include_environment     = optional(bool, true)
    use_short_environment   = optional(bool, false)
    include_global_location = optional(bool, true)
    split_on_label          = optional(string)
    label_order             = optional(list(string), [])
  })
  default = {}

  validation {
    condition = try(var.options.delimiter, null) == null || can(regex("^[a-zA-Z0-9-_]{0,3}$", var.options.delimiter))
    error_message = "options.delimiter must be up to three characters containing only alphanumeric characters, hyphen, or underscore."
  }

  validation {
    condition = try(var.options.split_on_label, null) == null || can(regex("^[a-zA-Z_]+$", var.options.split_on_label))
    error_message = "options.split_on_label must reference a label name (letters and underscores only)."
  }

  validation {
    condition = length(try(var.options.label_order, [])) == 0 || alltrue([
      for label in try(var.options.label_order, []) :
      contains([
        "prefix",
        "location",
        "namespace",
        "purpose",
        "attributes",
        "environment",
        "environment_instance"
      ], lower(label))
    ])
    error_message = "options.label_order may only contain the supported labels: prefix, location, namespace, purpose, attributes, environment, environment_instance."
  }

  validation {
    condition     = length(try(var.options.label_order, [])) == length(distinct([for label in try(var.options.label_order, []) : lower(label)]))
    error_message = "options.label_order must not contain duplicate labels."
  }
}

variable "overrides" {
  description = "Optional override maps for locations and environments."
  type = object({
    locations          = optional(map(string), {})
    environments       = optional(map(string), {})
    short_environments = optional(map(string), {})
  })
  default = {}

  validation {
    condition = alltrue([
      for k, v in try(var.overrides.locations, {}) :
      length(trimspace(k)) > 0 && can(regex("^[A-Za-z0-9]{2,6}$", trimspace(v)))
    ])
    error_message = "overrides.locations keys must be non-empty and values must be 2-6 alphanumeric characters."
  }

  validation {
    condition = alltrue([
      for k, v in try(var.overrides.environments, {}) :
      length(trimspace(k)) > 0 && length(trimspace(v)) > 0
    ])
    error_message = "overrides.environments keys and values must be non-empty strings."
  }

  validation {
    condition = alltrue([
      for k, v in try(var.overrides.short_environments, {}) :
      length(trimspace(k)) > 0 && can(regex("^[A-Za-z0-9]{2,6}$", trimspace(v)))
    ])
    error_message = "overrides.short_environments keys must be non-empty and values must be 2-6 alphanumeric characters."
  }
}

variable "tags" {
  description = "Controls for generated and user-supplied tags."
  type = object({
    include_generated = optional(bool, true)
    additional        = optional(map(string), {})
  })
  default = {}

  validation {
    condition = alltrue([
      for k, v in try(var.tags.additional, {}) :
      length(trimspace(k)) > 0 && length(trimspace(v)) > 0
    ])
    error_message = "tags.additional keys and values must be non-empty strings."
  }
}
