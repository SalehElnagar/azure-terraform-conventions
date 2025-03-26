  
#https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-resource#resourceid
locals {
  resource_name_start_index = 6

  resource_id         = var.resource_id
  resource_id_list    = split("/", trimprefix(local.resource_id, "/"))

  elementcount = length(local.resource_id_list)

  resource_id_keys    = [for i, k in local.resource_id_list : lower(k) if i % 2 == 0] 
  resource_id_values  = [for i, v in local.resource_id_list : v if i % 2 == 1] 
  resource_id_map     = zipmap(local.resource_id_keys, local.resource_id_values)

  is_subscription_level = length(local.resource_id_list) > 4

  subscription_id     = local.resource_id_map["subscriptions"]
  resource_group_name = local.resource_id_map["resourcegroups"]
  provider            = lookup(local.resource_id_map, "providers", null)

  resource_name_list  = slice(local.resource_id_list, local.resource_name_start_index, length(local.resource_id_list))
  resource_keys       = [for i, k in local.resource_name_list : k if i % 2 == 0] 
  resource_values     = [for i, v in local.resource_name_list : v if i % 2 == 1] 

  resource_type = join("/", flatten([local.provider, local.resource_keys]))

  base_resource_type = local.resource_keys[0]
  base_resource_name = local.resource_values[0]
 
  resource_name = reverse(local.resource_values)[0]

  resources = [for i,r in reverse(local.resource_keys) : {
    index = i
    type  = r
    value = reverse(local.resource_values)[i] 
  }]

  new_resource_map = merge({"resources" = local.resources}, local.resource_id_map)

}