## If the AKS already existed you need to connect the AKS with the ACR
# az aks update -g RG-UAE1-AKS-Cluster-Dev -n aks-uae1-aks-cluster-dev --attach-acr acruae1acrrepositorydev
## If you need the cluster to install the gatekeeper automatically to use Azure policy as an OPA you shoud enable the Azure policy on the main module on variable.tf file

resource "azurerm_resource_group" "aks" {
  name     = local.resource_group_name
  location = local.location

  tags = local.resource_group_tags
}


resource "random_id" "aks" {
  byte_length = 8
}

module "internal_aks_cluster" {
  source = "../infrastructure-terraform-azurerm-containers//modules/aks_cluster"

  name                      = local.aks_cluster_name
  location                  = azurerm_resource_group.aks.location
  resource_group_name       = azurerm_resource_group.aks.name
  node_resource_group_name  = local.node_resource_group_name

  dns_prefix = local.dns_prefix


  virtual_network_name                = data.azurerm_virtual_network.aks.name
  virtual_network_resource_group_name = data.azurerm_virtual_network.aks.resource_group_name

  admin_group_object_ids = data.azuread_groups.aks_admin.object_ids

  kubernetes_version = local.kubernetes_version

  ssh_public_key = local.ssh_public_key

  private_dns_zone = var.private_dns_zone

  private_cluster_enabled = false

  dns_service_ip      = "172.34.0.10"
  service_cidr        = "172.34.0.0/16"
  docker_bridge_cidr  = "172.17.0.1/16"

  default_node_pool_count       = local.default_node_pool_count
  default_node_pool_subnet_name = data.azurerm_subnet.aks["SUB-INT-AKS-Workload"].name

  additional_node_pools = local.additional_node_pools

  log_analytics_workspace = {
    name                = azurerm_log_analytics_workspace.aks.name
    resource_group_name = azurerm_log_analytics_workspace.aks.resource_group_name
  }


  container_registry_resource_ids = local.container_registry_resource_ids

  tags = local.aks_cluster_tags

  depends_on = [
    azurerm_resource_group.aks
  ]

}

resource "azurerm_role_assignment" "aks_admin" {
  count = length(data.azuread_groups.aks_admin.object_ids)

  scope                = module.internal_aks_cluster.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = data.azuread_groups.aks_admin.object_ids[count.index]
}

resource "azurerm_role_assignment" "aks_user" {
  count = length(data.azuread_groups.aks_user.object_ids)

  scope                = module.internal_aks_cluster.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = data.azuread_groups.aks_user.object_ids[count.index]
}

# AAD Pod Identity Role Assignments
# https://raw.githubusercontent.com/Azure/aad-pod-identity/master/hack/role-assignment.sh

locals {
  aks_node_resource_group_id = format("%s/resourceGroups/%s", data.azurerm_subscription.current.id, module.internal_aks_cluster.node_resource_group_name)
}

resource "azurerm_role_assignment" "aks_node_vm_contributor" {
  scope                = local.aks_node_resource_group_id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = module.internal_aks_cluster.identity_principal_id
}

resource "azurerm_role_assignment" "aks_node_managed_identity_operator" {
  scope                = local.aks_node_resource_group_id
  role_definition_name = "Managed Identity Operator"
  principal_id         =  module.internal_aks_cluster.identity_principal_id
}

resource "azurerm_role_assignment" "aks_cluster_managed_identity_operator" {
  scope                = azurerm_resource_group.aks.id
  role_definition_name = "Managed Identity Operator"
  principal_id         =  module.internal_aks_cluster.identity_principal_id
}

# Allow AKS cluster service principal to read certificates from encryption key vault
resource "azurerm_role_assignment" "aks_certificate_officer" {
  scope                = azurerm_key_vault.aks.id
  role_definition_name = "Key Vault Certificates Officer"
  principal_id         = module.internal_aks_cluster.identity_principal_id
}

# virtual machine scale set contributor rule for the DNS zone
resource "azurerm_role_assignment" "aks_node_vm_contributor2" {
  scope                = data.terraform_remote_state.vnet.outputs.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = module.internal_aks_cluster.identity_principal_id
}
