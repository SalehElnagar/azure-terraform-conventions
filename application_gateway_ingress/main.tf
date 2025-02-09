resource "azurerm_resource_group" "application_gateway_ingress" {
  name     = local.resource_group_name
  location = local.location

  tags = local.resource_group_tags
}

module "application_gateway_ingress" {
  source = "../../infrastructure-terraform-azurerm-network//modules/application_gateway_ingress"

  name                = local.application_gateway_name
  location            = azurerm_resource_group.application_gateway_ingress.location
  resource_group_name = azurerm_resource_group.application_gateway_ingress.name

  virtual_network_resource_group_name   = data.terraform_remote_state.vnet.outputs.resource_group_name
  virtual_network_name                  = data.terraform_remote_state.vnet.outputs.name
  virtual_network_subnet_name           = "SUB-INT-AKS-Ingress"

  private_ip_address = cidrhost(data.azurerm_subnet.application_gateway_ingress["SUB-INT-AKS-Ingress"].address_prefixes[0], 4)

  create_user_identity = true
 

  key_vault_ids = [data.terraform_remote_state.aks.outputs.key_vault_id]

  tags = local.application_gateway_tags

  depends_on = [
    azurerm_resource_group.application_gateway_ingress
  ]

}

output "all" {
  value = module.application_gateway_ingress
}