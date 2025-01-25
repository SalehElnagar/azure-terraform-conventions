
module "vpn_gateway" {
  source = "../../infrastructure-terraform-azurerm-network/modules/virtual_network_vpn_gateway"

  name                = local.vpn_gateway_name
  resource_group_name = data.azurerm_resource_group.vpn.name
  subnet_id           = local.subnet_id

  public_ip_name = local.public_ip

  site_to_site_connections = {
    "gateway" = {
      local_network_gateway_name              = local.local_network_gateway_name   
      virtual_network_gateway_connection_name = local.virtual_network_gateway_connection_name
      gateway_address = "160.0.1.1"
      address_space   = ["172.16.0.0/24", "172.16.1.0/24"]
      shared_key      = "abcslash!"
    }
  }
  tags = {
    application   = "Core"
    location      = "SWN"
    namespace     = "Topaz"
    purpose       = "VPN"
    provisioner   = "Terraform"
    environment   = "Stage"
    "Cost Center" = "D117 - A&D ERP Replacement"
  }

  depends_on = [
    data.azurerm_resource_group.vpn
  ]

}