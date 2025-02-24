locals {

  users               = [for u in var.azuread_objects: u if lower(u.type) == "user"]
  groups              = [for u in var.azuread_objects: u if lower(u.type) == "group"]
  service_principals  = [for u in var.azuread_objects: u if lower(u.type) == "serviceprincipal"]

}