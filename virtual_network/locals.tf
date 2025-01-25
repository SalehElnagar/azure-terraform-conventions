locals {
  defaults = {
    tags = {
      Provisioner = "Terraform"
      Application = var.cost_center # Remove after Application policy is gone
    }
  }

  resource_group_name         = module.resource_group_name.name
  virtual_network_name        = module.virtual_network_name.name
  # storage_account_name        = module.storage_account_name.name
  #network_security_group_name = module.network_resource_name.network_security_group_name
  location                    = var.location

  virtual_network_address_space = var.virtual_network_address_space
  region_address_space          = var.region_address_space
  virtual_network_type          = "Traditional"
  virtual_network_dns_servers   = var.virtual_network_dns_servers

  private_dns_zone_name = "topaz.online"

  internal_nsg_name_prefix = module.internal_network_security_group_components.name_prefix
  internal_nsg_name_suffix = module.internal_network_security_group_components.name_suffix
  internal_nsg_delimiter   = module.internal_network_security_group_components.delimiter

  external_nsg_name_prefix = module.external_network_security_group_components.name_prefix
  external_nsg_name_suffix = module.external_network_security_group_components.name_suffix
  external_nsg_delimiter   = module.external_network_security_group_components.delimiter

  rt_name_prefix = module.route_table_components.name_prefix
  rt_name_suffix = module.route_table_components.name_suffix
  rt_delimiter   = module.route_table_components.delimiter

  network_security_groups = [
    {
      type        = "Internal"
      name        = "Network",
      attributes  = ["Network"]
    },
    {
      type        = "External"
      name        = "Network-DMZ",
      attributes  = ["Network", "DMZ"]
    }
  ]

  network_security_rules = [
    {
      network_security_group     = "Network-DMZ"
      name                       = "Bastion_In_Allow"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    },
    {
      network_security_group     = "Network-DMZ"
      name                       = "Bastion_Control_In_Allow"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["443", "4443"]
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    },
    # {
    #   network_security_group     = "Network-DMZ"
    #   name                       = "Bastion_In_Deny"
    #   priority                   = 900
    #   direction                  = "Inbound"
    #   access                     = "Deny"
    #   protocol                   = "*"
    #   source_port_range          = "*"
    #   destination_port_range     = "*"
    #   source_address_prefix      = "*"
    #   destination_address_prefix = "*"
    # },
    {
      network_security_group     = "Network-DMZ"
      name                       = "Bastion_VNET_Out_Allow"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["22", "3389"]
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      network_security_group     = "Network-DMZ"
      name                       = "Bastion_Azure_Out_Allow"
      priority                   = 120
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["443"]
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud"
    }
  ]



  network_security_groups_map = { for n in local.network_security_groups : n.name => {
      type        = n.type
      name        = n.name
      attributes  = n.attributes
      delimiter   = n.type == "Internal" ? local.internal_nsg_delimiter : local.external_nsg_delimiter
      prefix      = n.type == "Internal" ? local.internal_nsg_name_prefix : local.external_nsg_name_prefix
      suffix      = n.type == "Internal" ? local.internal_nsg_name_suffix : local.external_nsg_name_suffix
  }}

  route_tables = [
    {
      name                          = "Network"
      attributes                    = ["Network"]
      disable_bgp_route_propagation = true
      routes                        = {
        DefaultRoute = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "Internet"
        }
      }
    }
  ]

  virtual_network_subnets = [
    {
      name            = "GatewaySubnet"
      address_prefix  = "10.40.3.0/24"
      route_table_name            = ""
      network_security_group_name = ""
      service_endpoints           = []
      delegations                 = []
    },
    {
      name            = "ApplicationSubnet"
      address_prefix  = "10.40.0.0/26"
      route_table_name            = "Network"
      network_security_group_name = "Network"
      service_endpoints           = [
        "Microsoft.Sql"
      ]
      delegations                 = []
    },
    {
      name            = "DatabaseSubnet"
      address_prefix  = "10.40.1.0/26"
      route_table_name            = "Network"
      network_security_group_name = "Network"
      service_endpoints           = []
      delegations                 = []
    },
    {
      name            = "AzureBastionSubnet"
      address_prefix  = "10.40.2.0/26"
      route_table_name            = ""
      network_security_group_name = "Network-DMZ"
      service_endpoints           = []
      delegations                 = []
    },
    {
      name                        = "SUB-INT-AKS-Workload"
      address_prefix  = "10.50.0.0/20"
      route_table_name            = ""
      network_security_group_name = ""
      service_endpoints = [
        "Microsoft.Sql",
        "Microsoft.KeyVault",
        "Microsoft.Storage"
      ]
      delegations                 = []
    },
    {
      name                        = "SUB-INT-AKS-Ingress"
      address_prefix  = "10.50.16.0/23"
      route_table_name            = ""
      network_security_group_name = ""
      service_endpoints           = []
      delegations                 = []
    },
    {
      name                        = "SUB-INT-Container-Group"
      address_prefix              = "10.50.18.0/23"
      route_table_name            = ""
      network_security_group_name = ""
      service_endpoints           = []
      delegations                 = [
        "Microsoft.ContainerInstance/containerGroups"
      ]
    }  

  ]

  nat_gateway_id = data.terraform_remote_state.nat.outputs.id
  nat_gateway_subnets = [
    "ApplicationSubnet",
    "DatabaseSubnet",
    "AzureBastionSubnet",
    "SUB-INT-AKS-Workload",
    "SUB-INT-AKS-Ingress",
    "SUB-INT-Container-Group"
  ]

  network_security_group_map = [
    for key, n in azurerm_network_security_group.network : {
      name  = key
      id    = n.id
    }
  ]
  
  route_table_map = [
    for key, r in azurerm_route_table.network : { 
      name  = key
      id    = r.id  
    }
  ]

  tags = merge(var.tags, {
    "Region Address Space"  = local.region_address_space
    "Network Type"          = local.virtual_network_type 
  })

  resource_group_tags         = merge(local.defaults.tags, module.resource_group_name.tags, local.tags)
  virtual_network_tags        = merge(local.defaults.tags, module.virtual_network_name.tags, local.tags)
  # storage_account_tags        = merge(local.defaults.tags, module.storage_account_name.tags, local.tags)
  route_table_tags            = merge(local.defaults.tags, module.route_table_components.tags, local.tags)
  network_security_group_tags = merge(local.defaults.tags, module.internal_network_security_group_components.tags, local.tags)
}
