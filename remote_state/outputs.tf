output "access_key" {
  value       = azurerm_storage_account.terraform_state.primary_access_key
  description = "Access key for terraform state storage account"
}

output "storage_account_name" {
  value = azurerm_storage_account.terraform_state.name
}

output "container_name" {
  value = azurerm_storage_container.terraform_state.name
}

