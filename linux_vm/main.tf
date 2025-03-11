resource "azurerm_linux_virtual_machine" "vm" {
  name                  = local.virtual_machine_name
  location              = local.location
  resource_group_name   = local.resource_group_name
  network_interface_ids = [azurerm_network_interface.vm.id]
  size                  = local.virtual_machine_size
  
  availability_set_id           = local.availability_set_id
  proximity_placement_group_id  = local.proximity_placement_group_id
  zone                          = local.availability_zone

  provision_vm_agent          = true
  allow_extension_operations  = true

  os_disk {
    name                    = join("_", [local.virtual_machine_name, "os", "disk"])
    disk_size_gb            = local.os_disk_size_gb
    caching                 = local.os_disk_caching
    storage_account_type    = local.os_disk_storage_account_type
    disk_encryption_set_id  = local.disk_encryption_set_id
  }

  source_image_id  = local.source_image_id
  source_image_reference {
    publisher = local.source_image_publisher
    offer     = local.source_image_offer
    sku       = local.source_image_sku
    version   = local.source_image_version
  }

  dynamic "plan" {
    for_each = local.source_image_plan != null ? [local.source_image_plan] : []

    content {
      name      = plan.value.name 
      product   = plan.value.product 
      publisher = plan.value.publisher
    }
  }

  admin_username                  = local.virtual_machine_user_name
  disable_password_authentication = true

  dynamic "admin_ssh_key" {
    for_each = [for k in local.virtual_machine_ssh_key_data : {
      public_key  = k
    }]

    content {
      username    = local.virtual_machine_user_name
      public_key  = admin_ssh_key.value.public_key
    }
  }

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

  dynamic "secret" {
    for_each = local.certificates != null ? [local.certificates] : []

    content {
      key_vault_id = secret.value.key_vault_id
      
      dynamic "certificate" {
        for_each = secret.value.secret_ids

        content {
          url = certificate.value 
        }
      }
    }
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.vm.primary_blob_endpoint
  }


  tags = local.tags

}