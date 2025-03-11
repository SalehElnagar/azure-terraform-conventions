locals {
  defaults = {
    private_ip_allocation_method = "Dynamic"
    dns_servers                  = []
  }

  resource_group_name                 = var.resource_group_name
  location                            = var.location
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  virtual_network_name                = var.virtual_network_name
  virtual_network_subnet_name         = var.virtual_network_subnet_name

  instances               = var.instances
  overprovision           = var.overprovision
  sku                     = var.sku
  single_placement_group  = var.single_placement_group
  
  zones                         = var.zones
  zone_balance                  = var.zones != null ? var.zone_balance : false
  proximity_placement_group_id  = var.proximity_placement_group_id
  platform_fault_domain_count   = var.platform_fault_domain_count

  vmss_name_prefix  = coalesce(var.vmss_name_prefix, try(module.vmss_name.name, var.vmss_name_prefix))
  vmss_user_name    = var.vmss_user_name
  vmss_ssh_key_data = var.vmss_ssh_key_data

  source_image_id         = var.source_image_id
  source_image_publisher  = var.source_image_publisher
  source_image_offer      = var.source_image_offer
  source_image_sku        = var.source_image_sku
  source_image_version    = var.source_image_version
  source_image_plan       = var.source_image_plan

  # Network
  dns_servers                                   = coalesce(var.dns_servers, [])
  network_security_group_id                     = var.network_security_group_id
  enable_accelerated_networking                 = var.enable_accelerated_networking
  load_balancer_backend_address_pool_ids        = var.load_balancer_backend_address_pool_ids
  application_gateway_backend_address_pool_ids  = var.application_gateway_backend_address_pool_ids
  application_security_group_ids                = var.application_security_group_ids
  
  #Azure OS Disk
  os_disk_size_gb               = var.os_disk_size_gb
  os_disk_storage_account_type  = var.os_disk_storage_account_type
  os_disk_caching               = var.os_disk_caching

  #Azure Data Disk
  data_disk_default_caching               = var.data_disk_default_caching
  data_disk_default_create_option         = var.data_disk_default_create_option
  data_disk_default_storage_account_type  = var.data_disk_default_storage_account_type
  data_disk_default_size_gb               = var.data_disk_default_size_gb
  data_disks                              = var.data_disks

  #Managed Identities
  identity_type_list = compact([
    var.enable_system_identity ? "SystemAssigned" : "",
    length(var.user_identity_ids) > 0 ? "UserAssigned" : ""
  ])

  identity_type = join(", ", local.identity_type_list)
  identity = {
    type         = local.identity_type
    identity_ids = length(compact(var.user_identity_ids)) > 0 ? compact(var.user_identity_ids) : null
  }

  identities = length(local.identity_type) > 0 ? [local.identity] : []

  system_identity_role_assignments = var.system_identity_role_assignments != null && var.enable_system_identity ? var.system_identity_role_assignments : []

  #Custom Data
  custom_data = var.custom_data

  # VM Custom Script Extension
  custom_script_enable = var.custom_script_enable
  custom_script_protected_settings = {
    "fileUris"         = var.custom_script_file_uris
    "commandToExecute" = var.custom_script_command
  }

  # Azure Disk Encryption
  disk_encryption_set_id = var.disk_encryption_set_id

  # SSL Certificates
  certificates = var.certificates

  # VMSS Upgrade
  upgrade_mode                      = var.upgrade_mode
  enable_automatic_os_upgrade       = var.enable_automatic_os_upgrade
  enable_automatic_instance_repair  = var.enable_automatic_instance_repair
  scale_in_policy                   = var.scale_in_policy
  health_probe_id                   = contains(["Automatic", "Rolling"], var.upgrade_mode) ? var.health_probe_id : null

  max_batch_instance_percent                = var.max_batch_instance_percent
  max_unhealthy_instance_percent            = var.max_unhealthy_instance_percent
  max_unhealthy_upgraded_instance_percent   = var.max_unhealthy_upgraded_instance_percent
  pause_time_between_batches                = var.pause_time_between_batches

  # Health Probe Extension
  enable_application_health_probe = var.enable_application_health_probe
  application_health_probe        = var.enable_application_health_probe ? {
    protocol      = var.application_health_probe.protocol
    port          = var.application_health_probe.port
    requestPath   = var.application_health_probe.request_path
  } : {}

  # Azure Monitor Log Analytics Extension
  azure_monitor_agent_enable    = (var.azure_monitor_agent_settings != null)
  azure_monitor_agent_settings  = var.azure_monitor_agent_settings

  #Tags
  tags = merge(try(module.tags.tags, {}), try(var.tags, {}))
}
