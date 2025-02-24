data "azuread_user" "object" {
  for_each = toset([ for u in local.users: u.id ])

  user_principal_name = each.key
}

data "azuread_group" "object" {
  for_each = toset([ for g in local.groups: g.id ])

  name = each.key
}

data "azuread_service_principal" "object" {
  for_each = toset([for sp in local.service_principals: sp.id])

  display_name = each.key
}

locals {

  object_ids = flatten([
    [ for o in data.azuread_user.object: o.object_id ],
    [ for o in data.azuread_group.object: o.object_id ],
    [ for o in data.azuread_service_principal.object: o.object_id ]
  ])

  data_map = {
    "user"              = data.azuread_user.object
    "group"             = data.azuread_group.object
    "serviceprincipal"  = data.azuread_service_principal.object
  }

  objects = [ for o in var.azuread_objects: {
    id        = o.id 
    type      = o.type
    object_id = local.data_map[lower(o.type)][o.id].object_id 
  }]

}