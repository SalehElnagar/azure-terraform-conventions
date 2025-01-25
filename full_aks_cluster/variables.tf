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

variable "purpose" {
  description = "Deployment purpose or name. Used to differentiate from other resources."
  default     = "AKS"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix specified when creating the managed cluster." 
  default     = "topaz-k8s"
}


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "kubernetes_version" {
  type        = string
  description = "The AKS Kubernetes version. Control plane and node pools."
  default     = "1.21.2"
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH key set for the Linux admin user."
  default     = null
}

variable "default_node_pool_count" {
  type        = number
  description = "The number of nodes in the default node pool."
  default     = 2 
}

variable "private_dns_zone" {
  type        = object({
    name                = string
    resource_group_name = string
  })
  description = "The private DNS zone for the private endpoint. This is required when this is a private cluster."
  default     = null
}

variable "container_registry_resource_ids" {
  type        = list(string)
  description = "A list of resource ids to allow AKS to pull container images from. May be individual Container Registries or resource groups."
  default     = [""]
}

variable "attributes" {
  type        = list(string)
  description = "Additional attributes for the resources. Used to differentiate from other resources."
  default     = []
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
