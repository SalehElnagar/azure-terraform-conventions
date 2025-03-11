resource "azurerm_windows_virtual_machine" "vm" {
  name                  = local.virtual_machine_name
  location              = local.location
  resource_group_name   = local.resource_group_name
  network_interface_ids = [azurerm_network_interface.vm.id]
  size                  = local.virtual_machine_size
  availability_set_id   = local.availability_set_id
  zone                  = local.availability_zone
  license_type          = local.license_type

  provision_vm_agent          = true
  allow_extension_operations  = true

  os_disk {
    name                    = join("_", [local.virtual_machine_name, "os", "disk"])
    disk_size_gb            = local.os_disk_size_gb
    caching                 = local.os_disk_caching
    storage_account_type    = local.os_disk_storage_account_type
    disk_encryption_set_id  = local.disk_encryption_set_id
  }

  source_image_id = local.source_image_id

  dynamic "source_image_reference" {
    for_each = local.is_source_image_custom ? [] : ["source_image_reference"]
  
    content {
      publisher = local.source_image_publisher
      offer     = local.source_image_offer
      sku       = local.source_image_sku
      version   = local.source_image_version
    }
  }

  dynamic "plan" {
    for_each = local.source_image_plan != null && !local.is_source_image_custom ? [local.source_image_plan] : []

    content {
      name      = plan.value.name 
      product   = plan.value.product 
      publisher = plan.value.publisher
    }
  }

  admin_username = local.virtual_machine_user_name
  admin_password = local.virtual_machine_password

  dynamic "identity" {
    for_each = [for i in local.identities : {
      type         = i.type
      identity_ids = i.identity_ids
    }]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vm.primary_blob_endpoint
  }

  proximity_placement_group_id = local.proximity_placement_group_id

  tags = local.tags
}