
# data "azurerm_resources" "network_watcher" {
#   type = "Microsoft.Network/networkWatchers"
# }

# locals {
#   network_watcher = [for i in data.azurerm_resources.network_watcher.resources: i if i.location == local.location][0]
# }

# module "network_watcher_resource_parser" {
#   source = "git::https://example@dev.azure.com/example/Aircraft%20Group%20IT/_git/infrastructure-terraform-azurerm-utilities//modules/resource_id_parser?ref=v0.1.0"

#   resource_id = local.network_watcher.id
# }

# data "azurerm_network_watcher" "log" {
#   name                = local.network_watcher.name
#   resource_group_name = module.network_watcher_resource_parser.resource_group_name
# }

data "terraform_remote_state" "nat" {
  backend = "azurerm"
  config = {
    storage_account_name = var.storageName
    container_name       = "terraform"
    access_key           =  var.key
    key                  = "nat_gateway.tfstate"
  }
}