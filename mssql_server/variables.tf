# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  type        = string
  description = "The name of the SQL Server."
}

variable "location" {
  type        = string
  description = "The location in Azure to deploy the resource."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group for the SQL Server resources."
}

variable "namespace" {
  type        = string
  description = "Namespace or owning group for conventions-based naming/tags."
  default     = "example"
}

variable "application" {
  type        = string
  description = "Application identifier for tag generation."
  default     = "database"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., development, quality, production)."
  default     = "development"
}

variable "purpose" {
  type        = string
  description = "Purpose label used in conventions-based naming."
  default     = "mssql"
}

variable "attributes" {
  type        = list(string)
  description = "Additional name attributes for conventions-based naming."
  default     = []
}

variable "azuread_administrator_object_id" {
  description = "The Id of the principal to set as the server administrator."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "administrator_login" {
  description = "The administrator login name for the new server. Changing this forces a new resource to be created."
  default     = null
}

variable "administrator_login_password" {
  description = "The password associated with the administrator_login user."
  default     = null
}

variable "azuread_administrator_login" {
  description = "The login name of the principal to set as the server administrator."
  default     = null
}

variable "connection_policy" {
  description = "The connection policy the server will use. Valid values are 'Default', 'Proxy', 'Redirect'."
  default     = "Default"

  validation {
    condition     = contains(["Default", "Proxy", "Redirect"], var.connection_policy)
    error_message = "The connection policy must be one of the following: 'Default', 'Proxy', 'Redirect'."
  }
}

variable "enable_system_identity" {
  type        = bool
  description = "Assign a system managed identity to the SQL Server."
  default     = false
}

variable "data_encryption" {
  type = object({
    key_vault_resource_group_name = string
    key_vault_name                = string
    key_name                      = string
    create_key                    = bool
  })
  description = "Transparent Data Encryption settings."
  default     = null
}

variable "firewall_allow_azure_access" {
  type        = bool
  description = "Allow Azure IP ranges to be allowed through the SQL Server firewall."
  default     = false
}

variable "firewall_ip_rules" {
  type        = list(object({
    name              = optional(string)
    start_ip_address  = string
    end_ip_address    = optional(string)
  }))
  description = "List of IP based firewall rules."
  default     = []
}

variable "firewall_virtual_network_rules" {
  type        = map(string)
  description = "Map of virtual network subnet ids to allow through the SQL Server firewall."
  default     = {}
}

variable "audit_retention_days" {
  type        = number
  description = "Sets how many days audits should be stored."
  default     = 90

  validation {
    condition     = var.audit_retention_days >= 0
    error_message = "The retention period for Audits must be greater or equal to 0."
  }
}

variable "security_retention_days" {
  type        = number
  description = "Sets how many days threat detection logs should be stored."
  default     = 90

  validation {
    condition     = var.security_retention_days >= 0
    error_message = "The retention period for threat detection logs must be greater or equal to 0."
  }
}

variable "security_email_account_admins" {
  type        = bool
  description = "Specifies if the alert is sent to the account administrators or not."
  default     = false
}

variable "security_email_addresses" {
  type        = list(string)
  description = "Specifies an array of e-mail addresses to which the alert is sent."
  default     = []

  validation {
    condition     = var.security_email_addresses != null
    error_message = "The security email address list must not be null."
  }
}

# Database retention settings

variable "enable_database_retention" {
  type        = bool
  description = "Sets short and long term retention policies on each database."
  default     = false
}

variable "database_short_term_retention_days" {
  type        = number
  description = "Point In Time Restore configuration."
  default     = 7

  validation {
    condition     = var.database_short_term_retention_days >=7 && var.database_short_term_retention_days <= 35
    error_message = "The short term retention period must be between 7 and 35 days."
  }
}

variable "database_long_term_retention" {
  type        = object({
    weekly_retention  = optional(string) #"P5W"  # 5 weeks
    monthly_retention = optional(string) #"P13M" # 13 months
    yearly_retention  = optional(string) #"P1Y"  # 1 year
    week_of_year      = optional(number) #1
  })
  description = "Long-term restore configuration."
  default     =   {
    weekly_retention  = "P1W"   # 1 week
    monthly_retention = "P1M"   # 1 month
    yearly_retention  = "P0Y"   # 0 years
  }
}

variable "private_endpoint" {
  type = object({
    virtual_network_name                = string
    virtual_network_resource_group_name = string
    subnet_name                         = string
    is_manual_connection                = bool
  })
  description = "The Private Endpoint information for the SQL Server."
  default     = null
}

variable "database_create_mode" {
  type        = string
  description = "The create mode of the database. Primary databases are empty, Secondary creates an OnlineSecondary database."
  default     = "Primary"

  validation {
    condition     = contains(["primary", "secondary"], lower(var.database_create_mode))
    error_message = "The database_mode must be either 'Primary' or 'Secondary'."
  }
}

variable "databases" {
  type = map(object({
    max_size_gb    = optional(number)
    read_scale     = optional(bool)
    sku_name       = optional(string)
    zone_redundant = optional(bool)
  }))
  description = "List of databases to create on the SQL Server."
  default     = {}
}

variable "replicated_databases" {
  type = map(object({
    source_database_id  = string
    max_size_gb         = optional(number)
    read_scale          = optional(bool)
    sku_name            = optional(string)
    zone_redundant      = optional(bool)
  }))
  description = "List of OnlineSecondary replica databases to create on the SQL Server."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "The list of Azure tags for the resource."
  default     = {}
}
