resource "azurerm_public_ip" "vm" {
  count = local.public_ip_create ? 1 : 0

  name                = local.virtual_machine_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = local.public_ip_sku
  allocation_method   = local.public_ip_allocation_method
}

resource "azurerm_network_interface" "vm" {
  name                = local.virtual_machine_nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dns_servers                   = local.dns_servers
  enable_accelerated_networking = local.enable_accelerated_networking

  ip_configuration {
    name                          = join("-", [local.virtual_machine_nic_name, "config"])
    subnet_id                     = data.azurerm_subnet.network.id
    private_ip_address            = local.private_ip_address
    private_ip_address_allocation = local.private_ip_allocation_method
    public_ip_address_id          = local.public_ip_create ? azurerm_public_ip.vm[0].id : null
  }

  tags = local.tags
}

//Not liking for_each, switching to count
resource "azurerm_network_interface_backend_address_pool_association" "vm" {
  count = length(local.load_balancer_backend_address_pools_ids)

  network_interface_id    = azurerm_network_interface.vm.id
  ip_configuration_name   = "${local.virtual_machine_nic_name}-config"
  backend_address_pool_id = local.load_balancer_backend_address_pools_ids[count.index]
}

resource "azurerm_network_interface_nat_rule_association" "vm" {
  count = length(local.load_balancer_inbound_nat_rules_ids)

  network_interface_id  = azurerm_network_interface.vm.id
  ip_configuration_name = "${local.virtual_machine_nic_name}-config"
  nat_rule_id           = local.load_balancer_inbound_nat_rules_ids[count.index]
}

resource "azurerm_network_interface_application_security_group_association" "vm" {
  count = length(local.application_security_group_ids)

  network_interface_id          = azurerm_network_interface.vm.id
  application_security_group_id = local.application_security_group_ids[count.index]
}