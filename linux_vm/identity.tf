
// Necessary until terraform error resolved
// https://github.com/terraform-providers/terraform-provider-azurerm/issues/4532
// https://github.com/hashicorp/terraform/issues/25578
data "azurerm_virtual_machine" "vm" {
  name                = azurerm_linux_virtual_machine.vm.name
  resource_group_name = azurerm_linux_virtual_machine.vm.resource_group_name

  //Important
  depends_on = [
    azurerm_linux_virtual_machine.vm
  ]
}

resource "random_uuid" "system_identity_custom_role_assignment" {
  for_each = toset(local.system_identity_role_assignments)

  keepers = {
    id = each.key
  }

}

resource "azurerm_role_assignment" "system_identity" {
  for_each = toset(local.system_identity_role_assignments)

  name               = random_uuid.system_identity_custom_role_assignment[each.key].result
  scope              = format("%s/resourceGroups/%s", data.azurerm_subscription.current.id, data.azurerm_virtual_machine.vm.resource_group_name)
  role_definition_id = data.azurerm_role_definition.vm[each.key].id
  principal_id       = data.azurerm_virtual_machine.vm.identity[0].principal_id

}