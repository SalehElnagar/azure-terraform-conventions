data "azurerm_resource_group" "network" {
  name = local.virtual_network_resource_group_name
}

data "azurerm_subnet" "network" {
  name                 = local.virtual_network_subnet_name
  virtual_network_name = local.virtual_network_name
  resource_group_name  = local.virtual_network_resource_group_name
}

resource "azurerm_public_ip" "vm" {
  count = local.public_ip_create ? 1 : 0

  name                = local.virtual_machine_public_ip_name
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = local.public_ip_sku
  allocation_method   = local.public_ip_allocation_method

  tags = local.tags
}

resource "azurerm_network_interface" "vm" {
  name                = local.virtual_machine_nic_name
  location            = local.location
  resource_group_name = local.resource_group_name

  dns_servers                   = local.dns_servers
  enable_accelerated_networking = local.enable_accelerated_networking

  ip_configuration {
    name                          = local.virtual_machine_nic_ip_config_name
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
  ip_configuration_name   = local.virtual_machine_nic_ip_config_name
  backend_address_pool_id = local.load_balancer_backend_address_pools_ids[count.index]
}

resource "azurerm_network_interface_nat_rule_association" "vm" {
  count = length(local.load_balancer_inbound_nat_rules_ids)

  network_interface_id  = azurerm_network_interface.vm.id
  ip_configuration_name = local.virtual_machine_nic_ip_config_name
  nat_rule_id           = local.load_balancer_inbound_nat_rules_ids[count.index]
}

resource "azurerm_network_interface_application_security_group_association" "vm" {
  count = length(local.application_security_group_ids)

  network_interface_id          = azurerm_network_interface.vm.id
  application_security_group_id = local.application_security_group_ids[count.index]
}