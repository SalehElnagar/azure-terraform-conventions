// output "kubernetes" {
//   value = module.internal_aks_cluster
// }
output "key_vault_id" {
  value       = azurerm_key_vault.aks.id
  description = "The Azure Key Vault Id."
}
output "key_vault_name" {
  value       = local.key_vault_name
}
output "key_vault_resource_group" {
  value       = azurerm_resource_group.aks.name
}

output "aks_resource_group" {
  value       = azurerm_resource_group.aks.name
}
output "aks_nodes_resource_group" {
  value       = local.node_resource_group_name
}