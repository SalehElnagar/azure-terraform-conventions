locals {
  defaults = {
    tags = {
      Provisioner = "Terraform"
      #Application = var.cost_center
    }
  }

  resource_group_name           = module.resource_group_name.name
  node_resource_group_name      = module.node_resource_group_name.name
  aks_cluster_name              = module.aks_cluster_name.name
  key_vault_name                = substr(join("-", [module.key_vault_name.name, random_id.aks.hex]), 0, 24) // TODO: Remove join when deployments stabilize
  disk_encryption_set_name      = module.disk_encryption_set_name.name
  log_analytics_workspace_name  = join("-", [module.log_analytics_workspace_name.name, random_id.aks.hex]) // TODO: Remove join when deployments stabilize
  location                      = var.location

  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  ssh_public_key = var.ssh_public_key

  aad_admin_group_names = [
    "AKS-admins"
  ]

  aad_user_group_names = [
    "AKS-users"
  ]

  default_node_pool_count = var.default_node_pool_count

  additional_node_pools = {
    "application" = {
      vnet_subnet_id  = data.azurerm_subnet.aks["SUB-INT-AKS-Workload"].id
      # vm_size         = "Standard_DS4_v2"
      # taints              = ["dedicated=node3:NoSchedule"]
      node_count      = 2
      node_labels     = {
        "salehelnaggar.io/bloop" = "application"
      }
    }
  }

  container_registry_resource_ids = data.terraform_remote_state.acr.outputs.id

  resource_group_tags           = merge(module.resource_group_name.tags, local.defaults.tags)
  aks_cluster_tags              = merge(module.aks_cluster_name.tags, local.defaults.tags)
  key_vault_tags                = merge(module.key_vault_name.tags, local.defaults.tags)
  disk_encryption_set_tags      = merge(module.disk_encryption_set_name.tags, local.defaults.tags)
  log_analytics_workspace_tags  = merge(module.log_analytics_workspace_name.tags, local.defaults.tags)

}
