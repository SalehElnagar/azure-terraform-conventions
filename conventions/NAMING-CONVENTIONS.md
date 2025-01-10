# Corporate Azure Naming Convention Modules

## Why these modules exist

Enterprise Azure estates demand predictable, policy-compliant names, tags, and metadata so that governance, cost allocation, and automation can run without manual curation. The modules in this repository were designed to solve the most common governance gaps we found across large Azure tenants:

- **Consistent resource identities.** Every resource must express the same combination of business context (namespace, purpose, environment, instance) using a deterministic delimiter and label order.
- **Location and environment standardisation.** Azure exposes more than 60 geography strings that evolve over time. We map those raw inputs to a canonical short code so downstream systems (CMDB, billing) stay consistent.
- **Tag policy enforcement.** Tags power automation, chargeback, and compliance. The modules merge generated metadata with corporate defaults and curated user inputs.
- **Secure-by-default flexibility.** We embrace object-based inputs so teams can override behaviour (custom maps, label order, split names) without copying the module internals.

If a team only had this markdown file, the explanations and embedded source code below are sufficient to understand the design intent, re-create the modules, and consume them from Terraform.

## Design principles

1. **Structured inputs over loose variables.** Each module receives a single object for its primary configuration (for example, `var.naming` or `var.metadata`) so all related settings travel together.
2. **Defensive validation.** We fail early with Terraform `validation` blocks and output `precondition`s whenever an input would produce an invalid Azure name or tag.
3. **Override-friendly defaults.** Core maps (locations, environments) ship with comprehensive defaults but accept overrides so organisations can introduce bespoke codes without forking.
4. **Idempotent outputs.** Every string is trimmed, normalised, and case-adjusted so repeated runs emit the same value regardless of caller formatting.
5. **Zero hidden state.** All derived values (`name_context`, generated tags, etc.) are exposed via outputs so callers can compose additional governance logic.

## Module architecture

The convention library is composed of three Terraform modules plus a shared helper:

- [`modules/common`](#modulescommon) centralises shared maps for locations, environments, and base tags.
- [`modules/resource`](#modulesresource) builds resource names suitable for global Azure resources with optional prefix/suffix splitting.
- [`modules/resource_group`](#modulesresource_group) generates opinionated resource group names.
- [`modules/tags`](#modulestags) produces a deterministic tag set from a minimal metadata object.

Each module is fully documented inline, and the source is reproduced below.

## Development approach

The modules were authored with the following workflow:

1. **Baseline maps and defaults.** We compiled the authoritative list of Azure regions and standard environment codes into `modules/common` and exposed them via outputs.
2. **Structured input contracts.** Each module defines a single required object input (`naming` or `metadata`) and optional `options`, `overrides`, and `tags` objects with strict validation.
3. **Normalisation pipeline.** `main.tf` files transform raw inputs: trim whitespace, replace illegal characters, merge overrides, and build a `name_context` map.
4. **Composable outputs.** Outputs return the assembled name(s), supporting context, and generated tags. Resource modules include preconditions that surface actionable errors when unsupported locations or environments are provided.
5. **Examples-first documentation.** Reference configurations in `/examples` and the standard `README.md` demonstrate typical usage patterns. The quick-start section below distils the essentials.

## Quick-start usage

```hcl
module "naming" {
  source = "../modules/resource"

  naming = {
    prefix               = "PLT"
    location             = "westeurope"
    namespace            = "platform"
    purpose              = "aks"
    environment          = "production"
    environment_instance = 1
    attributes           = ["core"]
  }

  options = {
    split_on_label = "purpose" # exposes prefix/suffix outputs for dependent resources
  }

  overrides = {
    locations = { "westeurope" = "WEU" }
  }

  tags = {
    include_generated = true
    additional = {
      "CostCenter" = "12345"
      "Service"    = "Kubernetes"
    }
  }
}
```

The outputs of the module (for example, `module.naming.name`, `module.naming.tags`) can be passed directly into resource definitions. Apply the same pattern with `modules/resource_group` when naming resource groups, and use `modules/tags` to enrich workloads that only need tags.

---

## `modules/common`
### `modules/common/maps.tf`

```hcl
locals {
  canonical_location_map = {
    "australia central"        = "AUC"
    "australia central 2"      = "AUC2"
    "australia east"           = "AUE"
    "australia southeast"      = "AUS"
    "brazil south"             = "BRS"
    "brazil southeast"         = "BRSE"
    "canada central"           = "CAC"
    "canada east"              = "CAE"
    "central india"            = "CIN"
    "central us"               = "CUS"
    "central us euap"          = "CUSE"
    "china east"               = "CHE"
    "china east 2"             = "CHE2"
    "china north"              = "CHN"
    "china north 2"            = "CHN2"
    "east asia"                = "EAS"
    "east us"                  = "EUS"
    "east us 2"                = "EUS2"
    "east us 2 euap"           = "EUS2E"
    "france central"           = "FRC"
    "france south"             = "FRS"
    "germany north"            = "GEN"
    "germany west central"     = "GEW"
    "germany central"          = "GEC"
    "germany northeast"        = "GENE"
    "israel central"           = "ISC"
    "italy north"              = "ITN"
    "japan east"               = "JPE"
    "japan west"               = "JPW"
    "jio india central"        = "JIC"
    "jio india west"           = "JIW"
    "korea central"            = "KOC"
    "korea south"              = "KOS"
    "north central us"         = "NCU"
    "north europe"             = "NEU"
    "norway east"              = "NOE"
    "norway west"              = "NOW"
    "poland central"           = "PLC"
    "qatar central"            = "QTC"
    "south africa north"       = "SAN"
    "south africa west"        = "SAW"
    "south central us"         = "SCU"
    "south india"              = "SIN"
    "south korea central"      = "SKC"
    "sweden central"           = "SWC"
    "sweden south"             = "SWS"
    "switzerland north"        = "SWN"
    "switzerland west"         = "SWW"
    "uae central"              = "UAC"
    "uae north"                = "UAN"
    "uk south"                 = "UKS"
    "uk west"                  = "UKW"
    "west central us"          = "WCU"
    "west europe"              = "WEU"
    "west india"               = "WIN"
    "west us"                  = "WUS"
    "west us 2"                = "WUS2"
    "west us 3"                = "WUS3"
    "global"                   = "GLO"
  }

  azure_location_map = merge(
    local.canonical_location_map,
    { for k, v in local.canonical_location_map : replace(k, " ", "") => v },
    { for k, v in local.canonical_location_map : replace(k, " ", "-") => v }
  )

  vm_environment_map = {
    "development"     = "D"
    "quality"         = "Q"
    "production"      = "P"
    "test"            = "T"
    "sandbox"         = "S"
    "nonproduction"   = "N"
    "preproduction"   = "R"
    "stage"           = "ST"
    "disasterrecovery" = "DR"
    "training"        = "TR"
  }

  environment_map = {
    "development"     = "Dev"
    "quality"         = "QA"
    "production"      = "Prod"
    "test"            = "Test"
    "sandbox"         = "SB"
    "nonproduction"   = "NP"
    "preproduction"   = "Prep"
    "stage"           = "Stg"
    "disasterrecovery" = "DR"
    "training"        = "Train"
  }

  short_environment_map = {
    "development"     = "DEV"
    "quality"         = "QA"
    "production"      = "PRD"
    "test"            = "TST"
    "sandbox"         = "SB"
    "nonproduction"   = "NP"
    "preproduction"   = "PR"
    "stage"           = "STG"
    "disasterrecovery" = "DR"
    "training"        = "TRN"
  }

  tag_map = {
    "Provisioner" = "Terraform"
    "ManagedBy"   = "Terraform"
  }
}
```

### `modules/common/outputs.tf`

```hcl
output "locations" {
  value       = local.azure_location_map
  description = "Azure to enterprise location map"
}

output "environments" {
  value       = local.environment_map
  description = "Environments for most resources"
}

output "short_environments" {
  value       = local.short_environment_map
  description = "Shortened environments for most resources"
}

output "vm_environments" {
  value       = local.vm_environment_map
  description = "Shortened environments for virtual machines"
}

output "base_tags" {
  value       = local.tag_map
  description = "Base Tags for all resources"
}
```

## `modules/resource`
### `modules/resource/variables.tf`

```hcl
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
```

### `modules/resource/main.tf`

```hcl
locals {
  defaults = {
    label_order         = ["prefix", "location", "namespace", "environment_instance", "purpose", "attributes", "environment"]
    delimiter           = "-"
    regex_replace_chars = "/[^a-zA-Z0-9-]/"
    replacement         = ""
  }

  options = {
    standardize             = try(var.options.standardize, true)
    delimiter               = try(var.options.delimiter, null)
    regex_replace_chars     = try(var.options.regex_replace_chars, null)
    include_environment     = try(var.options.include_environment, true)
    use_short_environment   = try(var.options.use_short_environment, false)
    include_global_location = try(var.options.include_global_location, true)
    split_on_label          = try(var.options.split_on_label, null)
    label_order             = try(var.options.label_order, [])
  }

  tags_config = {
    include_generated = try(var.tags.include_generated, true)
    additional        = try(var.tags.additional, {})
  }

  overrides = {
    locations = {
      for k, v in try(var.overrides.locations, {}) :
      lower(trimspace(k)) => upper(trimspace(v))
    }
    environments = {
      for k, v in try(var.overrides.environments, {}) :
      lower(trimspace(k)) => trimspace(v)
    }
    short_environments = {
      for k, v in try(var.overrides.short_environments, {}) :
      lower(trimspace(k)) => upper(trimspace(v))
    }
  }

  label_order_source = length(local.options.label_order) > 0 ? local.options.label_order : local.defaults.label_order
  delimiter          = coalesce(local.options.delimiter, local.defaults.delimiter)
  regex_replace_chars = coalesce(local.options.regex_replace_chars, local.defaults.regex_replace_chars)

  prefix      = trimspace(var.naming.prefix)
  location    = trimspace(var.naming.location)
  namespace   = replace(trimspace(var.naming.namespace), local.regex_replace_chars, local.defaults.replacement)
  purpose     = replace(trimspace(var.naming.purpose), local.regex_replace_chars, local.defaults.replacement)
  attributes  = [for attribute in try(var.naming.attributes, []) : replace(trimspace(attribute), local.regex_replace_chars, local.defaults.replacement)]
  environment = trimspace(var.naming.environment)
  environment_instance = try(var.naming.environment_instance, 0)

  label_order = [
    for label in local.label_order_source :
    lower(label)
  ]

  split_index = local.options.split_on_label != null ? (contains(local.label_order, lower(local.options.split_on_label)) ? index(local.label_order, lower(local.options.split_on_label)) : null) : null
  is_split    = local.split_index != null

  is_global_location = lower(local.location) == "global"
  include_location   = (local.options.include_global_location && local.is_global_location) || !local.is_global_location

  user_tags = {
    for k, v in local.tags_config.additional :
    title(replace(trimspace(k), local.regex_replace_chars, local.defaults.replacement)) => trimspace(v)
    if length(trimspace(k)) > 0 && length(trimspace(v)) > 0
  }

  tags = local.user_tags

  location_map = merge(
    module.common.locations,
    local.overrides.locations
  )

  environment_map_source = merge(
    module.common.environments,
    local.overrides.environments
  )

  short_environment_map_source = merge(
    module.common.short_environments,
    local.overrides.short_environments
  )

  environment_map = local.options.use_short_environment ? local.short_environment_map_source : local.environment_map_source

  mapped_location    = lookup(local.location_map, lower(local.location), null)
  mapped_environment = lookup(local.environment_map, lower(local.environment), null)

  padded_environment_instance = local.environment_instance == 0 ? "" : local.environment_instance

  name_context = {
    prefix               = local.prefix
    location             = local.include_location ? coalesce(local.mapped_location, "") : ""
    namespace            = local.namespace
    purpose              = local.purpose
    attributes           = join(local.delimiter, local.attributes)
    environment          = local.options.include_environment ? coalesce(local.mapped_environment, "") : ""
    environment_instance = local.padded_environment_instance
  }

  labels_to_remove = concat(
    !local.options.include_environment ? ["environment"] : [],
    []
  )

  label_order_final = [
    for label in local.label_order : label
    if !contains(local.labels_to_remove, label)
  ]

  labels = [
    for l in local.label_order_final :
    local.options.standardize ? lower(tostring(local.name_context[l])) : tostring(local.name_context[l])
    if length(tostring(local.name_context[l])) > 0
  ]

  prefix_labels = [
    for l in slice(local.label_order_final, 0, coalesce(local.split_index, 0)) :
    local.options.standardize ? lower(tostring(local.name_context[l])) : tostring(local.name_context[l])
    if(local.is_split && length(tostring(local.name_context[l])) > 0)
  ]

  suffix_labels = [
    for l in slice(local.label_order_final, coalesce(local.split_index, 0) + 1, length(local.label_order_final)) :
    local.options.standardize ? lower(tostring(local.name_context[l])) : tostring(local.name_context[l])
    if(local.is_split && length(tostring(local.name_context[l])) > 0)
  ]

  resource_name        = join(local.delimiter, local.labels)
  resource_name_prefix = join(local.delimiter, local.prefix_labels)
  resource_name_suffix = join(local.delimiter, local.suffix_labels)

  tags_context = {
    namespace              = local.namespace
    purpose                = local.purpose
    environment            = local.environment
    "EnvironmentInstance" = local.environment_instance
    location               = local.mapped_location
  }

  generated_tags = {
    for t in keys(local.tags_context) :
    title(t) => tostring(local.tags_context[t])
    if(length(tostring(local.tags_context[t])) > 0 && local.tags_config.include_generated)
  }

  resource_tags = merge(module.common.base_tags, local.generated_tags, local.tags)
}
```

### `modules/resource/outputs.tf`

```hcl
output "name" {
  value       = local.resource_name
  description = "Normalized name"
}

output "name_prefix" {
  value       = local.is_split ? local.resource_name_prefix : ""
  description = "The normalized name prefix"

  precondition {
    condition     = local.options.split_on_label == null || local.is_split
    error_message = format("options.split_on_label '%s' must be part of the resolved label order.", local.options.split_on_label)
  }
}

output "name_suffix" {
  value       = local.is_split ? local.resource_name_suffix : ""
  description = "The normalized name suffix"
}

output "name_context" {
  value       = local.name_context
  description = "Elements to construct the resource name"
}

output "location" {
  value       = local.mapped_location
  description = "The mapped enterprise location code corresponding to the original Azure location"

  precondition {
    condition     = local.mapped_location != null
    error_message = format("Location '%s' is not supported. Provide a custom_location_map entry or use a supported Azure region name.", local.location)
  }
}

output "namespace" {
  value       = local.namespace
  description = "Normalized namespace"
}

output "purpose" {
  value       = local.purpose
  description = "Normalized purpose"
}

output "attributes" {
  value       = local.attributes
  description = "List of attributes"
}

output "environment" {
  value       = local.environment
  description = "Original environment"

  precondition {
    condition     = local.mapped_environment != null
    error_message = format("Environment '%s' is not supported. Provide a custom_environment_map entry or use a supported environment name.", local.environment)
  }
}

output "environment_instance" {
  value       = local.environment_instance
  description = "Environment instance"
}

output "delimiter" {
  value       = local.delimiter
  description = "The delimiter used to separate components"
}

output "generated_tags" {
  value       = local.generated_tags
  description = "Tags that were generated as part of the resource name"
}

output "tags" {
  value       = local.resource_tags
  description = "Normalized Tag map"
}
```

### `modules/resource/maps.tf`

```hcl
module "common" {
  source = "../common"
}
```

## `modules/resource_group`
### `modules/resource_group/variables.tf`

```hcl
# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "naming" {
  description = "Object describing the resource group identity inputs."
  type = object({
    location             = string
    namespace            = string
    purpose              = string
    environment          = string
    prefix               = optional(string, "RG")
    environment_instance = optional(number, 0)
    attributes           = optional(list(string), [])
  })

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
    condition     = can(regex("^[A-Z]{1,4}$", upper(trimspace(try(var.naming.prefix, "RG")))))
    error_message = "naming.prefix must be 1-4 alphabetic characters."
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
    label_order             = optional(list(string), [])
  })
  default = {}

  validation {
    condition = try(var.options.delimiter, null) == null || can(regex("^[a-zA-Z0-9-_]{0,3}$", var.options.delimiter))
    error_message = "options.delimiter must be up to three characters containing only alphanumeric characters, hyphen, or underscore."
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
```

### `modules/resource_group/main.tf`

```hcl
locals {
  defaults = {
    label_order         = ["prefix", "location", "namespace", "environment_instance", "purpose", "attributes", "environment"]
    delimiter           = "-"
    regex_replace_chars = "/[^a-zA-Z0-9-]/"
    replacement         = ""
  }

  options = {
    standardize             = try(var.options.standardize, true)
    delimiter               = try(var.options.delimiter, null)
    regex_replace_chars     = try(var.options.regex_replace_chars, null)
    include_environment     = try(var.options.include_environment, true)
    use_short_environment   = try(var.options.use_short_environment, false)
    include_global_location = try(var.options.include_global_location, true)
    label_order             = try(var.options.label_order, [])
  }

  tags_config = {
    include_generated = try(var.tags.include_generated, true)
    additional        = try(var.tags.additional, {})
  }

  overrides = {
    locations = {
      for k, v in try(var.overrides.locations, {}) :
      lower(trimspace(k)) => upper(trimspace(v))
    }
    environments = {
      for k, v in try(var.overrides.environments, {}) :
      lower(trimspace(k)) => trimspace(v)
    }
    short_environments = {
      for k, v in try(var.overrides.short_environments, {}) :
      lower(trimspace(k)) => upper(trimspace(v))
    }
  }

  label_order_source = length(local.options.label_order) > 0 ? local.options.label_order : local.defaults.label_order
  delimiter          = coalesce(local.options.delimiter, local.defaults.delimiter)
  regex_replace_chars = coalesce(local.options.regex_replace_chars, local.defaults.regex_replace_chars)

  prefix               = upper(trimspace(try(var.naming.prefix, "RG")))
  location             = trimspace(var.naming.location)
  namespace            = replace(trimspace(var.naming.namespace), local.regex_replace_chars, local.defaults.replacement)
  purpose              = replace(trimspace(var.naming.purpose), local.regex_replace_chars, local.defaults.replacement)
  attributes           = [for attribute in try(var.naming.attributes, []) : replace(trimspace(attribute), local.regex_replace_chars, local.defaults.replacement)]
  environment          = trimspace(var.naming.environment)
  environment_instance = try(var.naming.environment_instance, 0)

  label_order = [
    for label in local.label_order_source :
    lower(label)
  ]

  is_global_location = lower(local.location) == "global"
  include_location   = (local.options.include_global_location && local.is_global_location) || !local.is_global_location

  user_tags = {
    for k, v in local.tags_config.additional :
    title(replace(trimspace(k), local.regex_replace_chars, local.defaults.replacement)) => trimspace(v)
    if length(trimspace(k)) > 0 && length(trimspace(v)) > 0
  }

  tags = local.user_tags

  location_map = merge(
    module.common.locations,
    local.overrides.locations
  )

  environment_map_source = merge(
    module.common.environments,
    local.overrides.environments
  )

  short_environment_map_source = merge(
    module.common.short_environments,
    local.overrides.short_environments
  )

  environment_map = local.options.use_short_environment ? local.short_environment_map_source : local.environment_map_source

  mapped_location    = lookup(local.location_map, lower(local.location), null)
  mapped_environment = lookup(local.environment_map, lower(local.environment), null)

  padded_environment_instance = local.environment_instance == 0 ? "" : local.environment_instance

  name_context = {
    prefix               = local.prefix
    location             = local.include_location ? coalesce(local.mapped_location, "") : ""
    namespace            = local.namespace
    purpose              = local.purpose
    attributes           = join(local.delimiter, local.attributes)
    environment          = local.options.include_environment ? coalesce(local.mapped_environment, "") : ""
    environment_instance = local.padded_environment_instance
  }

  label_order_final = [
    for label in local.label_order : label
  ]

  labels = [
    for l in local.label_order_final :
    local.options.standardize ? upper(tostring(local.name_context[l])) : tostring(local.name_context[l])
    if length(tostring(local.name_context[l])) > 0
  ]

  resource_group_name = join(local.delimiter, local.labels)

  tags_context = {
    namespace              = local.namespace
    purpose                = local.purpose
    environment            = local.environment
    "EnvironmentInstance" = local.environment_instance
    location               = local.mapped_location
  }

  generated_tags = {
    for t in keys(local.tags_context) :
    title(t) => tostring(local.tags_context[t])
    if(length(tostring(local.tags_context[t])) > 0 && local.tags_config.include_generated)
  }

  resource_tags = merge(module.common.base_tags, local.generated_tags, local.tags)
}
```

### `modules/resource_group/outputs.tf`

```hcl
output "name" {
  value       = local.resource_group_name
  description = "Normalized name"
}

output "name_context" {
  value       = local.name_context
  description = "Elements to construct the resource name"
}

output "location" {
  value       = local.mapped_location
  description = "The mapped enterprise location code corresponding to the original Azure location"

  precondition {
    condition     = local.mapped_location != null
    error_message = format("Location '%s' is not supported. Provide an overrides.locations entry or use a supported Azure region name.", local.location)
  }
}

output "namespace" {
  value       = local.namespace
  description = "Normalized namespace"
}

output "purpose" {
  value       = local.purpose
  description = "Normalized purpose"
}

output "attributes" {
  value       = local.attributes
  description = "List of attributes"
}

output "environment" {
  value       = local.environment
  description = "Original environment"

  precondition {
    condition     = local.mapped_environment != null
    error_message = format("Environment '%s' is not supported. Provide an overrides.environments entry or use a supported environment name.", local.environment)
  }
}

output "environment_instance" {
  value       = local.environment_instance
  description = "Environment instance"
}

output "generated_tags" {
  value       = local.generated_tags
  description = "Tags that were generated as part of the resource name"
}

output "tags" {
  value       = local.resource_tags
  description = "Normalized Tag map"
}
```

### `modules/resource_group/maps.tf`

```hcl
module "common" {
  source = "../common"
}
```

## `modules/tags`
### `modules/tags/variables.tf`

```hcl
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
```

### `modules/tags/main.tf`

```hcl
locals {

  defaults = {
    regex_replace_chars = "/[^a-zA-Z0-9-]/"
    replacement         = ""
  }

  sanitized_namespace   = replace(trimspace(var.metadata.namespace), local.defaults.regex_replace_chars, local.defaults.replacement)
  sanitized_application = replace(trimspace(var.metadata.application), local.defaults.regex_replace_chars, local.defaults.replacement)
  sanitized_environment = trimspace(var.metadata.environment)

  tags_context = {
    Provisioner = "Terraform"
    Namespace   = local.sanitized_namespace
    Application = local.sanitized_application
    Environment = local.sanitized_environment
  }

  generated_tags = {
    for t, v in local.tags_context :
    t => tostring(v)
    if length(tostring(v)) > 0
  }

  user_tags = {
    for k, v in try(var.metadata.additional, {}) :
    title(replace(trimspace(k), local.defaults.regex_replace_chars, local.defaults.replacement)) => trimspace(v)
    if length(trimspace(k)) > 0 && length(trimspace(v)) > 0
  }

  tags = merge(module.common.base_tags, local.generated_tags, local.user_tags)

}
```

### `modules/tags/outputs.tf`

```hcl
output "tags" {
  value       = local.tags
  description = "Tag map."
}
```

### `modules/tags/maps.tf`

```hcl
module "common" {
  source = "../common"
}
```

