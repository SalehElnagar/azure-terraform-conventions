variable "location" {
  description = "The location in Azure to deploy the resource."
}

variable "resource_group_name" {
  description = "The name of the resource group for the Terraform state container."
}

variable "storage_account_name" {
  description = "The name of the storage account for Terraform state files."
}

variable "storage_account_kind" {
  description = "The storage account kind."
  default     = ""
}

variable "storage_account_tier" {
  description = "The storage account tier."
  default     = ""
}

variable "storage_account_replication_type" {
  description = "The storage account replication type."
  default     = ""
}

variable "storage_access_tier" {
  description = "The storage account access tier."
  default     = ""
}

variable "storage_container_name" {
  description = "The storage container name."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "The list of Azure tags for the resource."
  default     = {}
}

