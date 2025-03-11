resource "random_uuid" "system_identity_custom_role_assignment" {
  for_each = toset(local.system_identity_role_assignments)

  keepers = {
    id = each.key
  }
}

resource "azurerm_role_assignment" "system_identity" {
  for_each = toset(local.system_identity_role_assignments)

  name               = random_uuid.system_identity_custom_role_assignment[each.key].result
  scope              = format("%s/resourceGroups/%s", data.azurerm_subscription.current.id, azurerm_linux_virtual_machine_scale_set.vmss.resource_group_name)
  role_definition_id = data.azurerm_role_definition.vmss[each.key].id
  principal_id       = azurerm_linux_virtual_machine_scale_set.vmss.identity[0].principal_id
}
