output "users" {
  value = data.azuread_user.object
}

output "groups" {
  value = data.azuread_group.object
}

output "service_principals" {
  value = data.azuread_service_principal.object
}

output "object_ids" {
  value = local.object_ids
}

output "objects" {
  value = local.objects
}