resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = local.vmss_name_prefix
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = local.sku
  provision_vm_agent  = true

  instances               = local.instances
  overprovision           = local.overprovision
  single_placement_group  = local.single_placement_group 

  zones                         = local.zones
  zone_balance                  = local.zone_balance
  proximity_placement_group_id  = local.proximity_placement_group_id
  platform_fault_domain_count   = local.platform_fault_domain_count

  admin_username                  = local.vmss_user_name
  disable_password_authentication = true

  dynamic "admin_ssh_key" {
    for_each = local.vmss_ssh_key_data

    content {
      username   = local.vmss_user_name
      public_key = admin_ssh_key.value
    }
  }

  source_image_id = local.source_image_id 

  dynamic "source_image_reference" {
    for_each = local.source_image_id == null ? ["source_image_reference"] : []

    content {
      publisher = local.source_image_publisher
      offer     = local.source_image_offer
      sku       = local.source_image_sku
      version   = local.source_image_version
    }
  }

  custom_data = local.custom_data

  os_disk {
    disk_size_gb              = local.os_disk_size_gb
    caching                   = local.os_disk_caching
    storage_account_type      = local.os_disk_storage_account_type
    disk_encryption_set_id    = local.disk_encryption_set_id
    write_accelerator_enabled = false
  }

  dynamic "data_disk" {
    for_each = local.data_disks

    content {
      storage_account_type      = coalesce(data_disk.value.storage_account_type, local.data_disk_default_storage_account_type)
      caching                   = coalesce(data_disk.value.caching, local.data_disk_default_caching)
      create_option             = coalesce(data_disk.value.create_option, local.data_disk_default_create_option)
      disk_size_gb              = coalesce(data_disk.value.disk_size_gb, local.data_disk_default_size_gb)
      lun                       = data_disk.value.lun
      disk_encryption_set_id    = local.disk_encryption_set_id
      write_accelerator_enabled = false
    }
  }

  # Primary Network
  network_interface {
    name    = "primary-nic"
    primary = true

    dns_servers                   = local.dns_servers
    network_security_group_id     = local.network_security_group_id
    enable_accelerated_networking = local.enable_accelerated_networking
    enable_ip_forwarding          = false

    ip_configuration {
      name      = "primary-nic-config"
      primary   = true
      subnet_id = data.azurerm_subnet.network.id

      application_gateway_backend_address_pool_ids  = local.application_gateway_backend_address_pool_ids
      application_security_group_ids                = local.application_security_group_ids              
      load_balancer_backend_address_pool_ids        = local.load_balancer_backend_address_pool_ids
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
    storage_account_uri = azurerm_storage_account.vmss.primary_blob_endpoint
  }

  # Health and Upgrades
  upgrade_mode    = local.upgrade_mode

  dynamic "rolling_upgrade_policy" {
    for_each = contains(["Automatic", "Rolling"], var.upgrade_mode) ? ["rolling_upgrade_policy"] : []

    content {
      max_batch_instance_percent              = local.max_batch_instance_percent
      max_unhealthy_instance_percent          = local.max_unhealthy_instance_percent 
      max_unhealthy_upgraded_instance_percent = local.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = local.pause_time_between_batches 
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = local.enable_automatic_os_upgrade && local.upgrade_mode == "Automatic" ? ["automatic_os_upgrade_policy"] : []

    content {
      disable_automatic_rollback  = true  # - (Required) Should automatic rollbacks be disabled? Changing this forces a new resource to be created.
      enable_automatic_os_upgrade = true  # - (Required) Should OS Upgrades automatically be applied to Scale Set instances in a rolling fashion when a newer version of the OS Image becomes available? Changing this forces a new resource to be created.
    }
  }

  health_probe_id = local.health_probe_id
  dynamic "extension" {
    for_each = (local.enable_application_health_probe && local.application_health_probe != null) ? ["extension"] : []

    content {
      name                        = join("-", [local.vmss_name_prefix, "health"]) 
      publisher                   = "Microsoft.ManagedServices"
      type                        = "ApplicationHealthLinux"
      type_handler_version        = "1.0"
      auto_upgrade_minor_version  = true
      protected_settings          = jsonencode(local.application_health_probe)
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = local.enable_automatic_instance_repair && contains(["Automatic", "Rolling"], var.upgrade_mode) ? ["automatic_os_upgrade_policy"] : []

    content {
      enabled       = true    # - (Required) Should the automatic instance repair be enabled on this Virtual Machine Scale Set?
      grace_period  = "PT30M" # - (Optional) Amount of time (in minutes, between 30 and 90, defaults to 30 minutes) for which automatic repairs will be delayed. The grace period starts right after the VM is found unhealthy. The time duration should be specified in ISO 8601 format.
    }
  }

  scale_in_policy = local.scale_in_policy

  tags = local.tags

  lifecycle {
    ignore_changes = [
      data_disk["*"].storage_account_type,
    ]
  }

}
