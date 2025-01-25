resource "azurerm_network_security_group" "network" {
  for_each = { for n in local.network_security_groups_map : n.name => n }

  name                = join(each.value.delimiter, compact(flatten([each.value.prefix, each.value.attributes, each.value.suffix])))
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  tags = local.resource_group_tags
}


resource "azurerm_network_security_rule" "network" {
  for_each = { for r in local.network_security_rules : r.name => r }

  name                    = each.key
  priority                = each.value.priority
  direction               = each.value.direction
  description             = lookup(each.value, "description", null)
  access                  = lookup(each.value, "access", "Deny")
  protocol                = lookup(each.value, "protocol", "*")
  source_port_range       = lookup(each.value, "source_port_range", null)
  destination_port_range  = lookup(each.value, "destination_port_range", null)
  source_port_ranges      = lookup(each.value, "source_port_ranges", null)
  destination_port_ranges = lookup(each.value, "destination_port_ranges", null)

  source_address_prefix                      = lookup(each.value, "source_address_prefix", null)
  destination_address_prefix                 = lookup(each.value, "destination_address_prefix", null)
  source_application_security_group_ids      = lookup(each.value, "source_application_security_group_ids", null)
  destination_application_security_group_ids = lookup(each.value, "destination_application_security_group_ids", null)

  resource_group_name         = azurerm_network_security_group.network[each.value.network_security_group].resource_group_name
  network_security_group_name = azurerm_network_security_group.network[each.value.network_security_group].name
}

# resource "azurerm_storage_account" "log" {
#   name                      = local.storage_account_name
#   resource_group_name       = azurerm_resource_group.network.name
#   location                  = azurerm_resource_group.network.location
#   account_tier              = "Standard"
#   account_kind              = "StorageV2"
#   account_replication_type  = "LRS"
#   access_tier               = "Hot"

#   enable_https_traffic_only = true
#   #allow_blob_public_access  = false

#   #https://docs.microsoft.com/en-us/network-watcher/network-watcher-nsg-flow-logging-overview
#   network_rules {
#     default_action  = "Deny"
#     bypass          = ["AzureServices"]
#   }

#   tags = local.storage_account_tags
# }

# resource "azurerm_network_watcher_flow_log" "network" {
#   for_each = { for n in local.network_security_group_map : n.name => n }

#   network_watcher_name = data.azurerm_network_watcher.log.name
#   resource_group_name  = data.azurerm_network_watcher.log.resource_group_name

#   network_security_group_id = azurerm_network_security_group.network[each.key].id
#   storage_account_id        = azurerm_storage_account.log.id
#   enabled                   = true

#   retention_policy {
#     enabled = true
#     days    = 14
#   }

  // traffic_analytics {
  //   enabled               = true
  //   workspace_id          = data.azurerm_log_analytics_workspace.log[0].workspace_id
  //   workspace_region      = data.azurerm_log_analytics_workspace.log[0].location
  //   workspace_resource_id = data.azurerm_log_analytics_workspace.log[0].id
  //   interval_in_minutes   = 10
  // }
