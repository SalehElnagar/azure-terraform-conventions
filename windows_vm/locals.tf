locals {
  defaults = {

    source_image_publisher = "MicrosoftWindowsServer"
    source_image_offer     = "WindowsServer"
    source_image_sku       = "2019-Datacenter"
    source_image_version   = "latest"

    virtual_machine_size = "Standard_D2s_v3"

    public_ip_sku                = "Basic"
    public_ip_allocation_method  = "Dynamic"
    private_ip_allocation_method = "Dynamic"
    dns_servers                  = []

    os_disk_storage_account_type  = "StandardSSD_LRS"
    os_disk_caching               = "None"

    data_disk_default_caching               = "None"
    data_disk_default_create_option         = "Empty"
    data_disk_default_storage_account_type  = "StandardSSD_LRS"
    data_disk_default_size_gb               = 32

    encrypt_os_disk   = false
    encrypt_data_disk = false

    identities = []
  }

  resource_group_name                 = var.resource_group_name
  location                            = var.location
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  virtual_network_name                = var.virtual_network_name
  virtual_network_subnet_name         = var.virtual_network_subnet_name

  proximity_placement_group_id = var.proximity_placement_group_id
  availability_set_id          = var.availability_set_id
  availability_zone            = var.availability_zone
  virtual_machine_size         = coalesce(var.virtual_machine_size, local.defaults.virtual_machine_size)

  source_image_publisher  = coalesce(var.source_image_publisher, local.defaults.source_image_publisher)
  source_image_offer      = coalesce(var.source_image_offer, local.defaults.source_image_offer)
  source_image_sku        = coalesce(var.source_image_sku, local.defaults.source_image_sku)
  source_image_version    = coalesce(var.source_image_version, local.defaults.source_image_version)
  source_image_plan       = var.source_image_plan
  source_image_id         = var.source_image_id
  is_source_image_custom  = var.source_image_id != null ? true : false

  license_type = var.license_type

  virtual_machine_name      = coalesce(var.virtual_machine_name, try(module.vm_name.name, var.virtual_machine_name))
  virtual_machine_user_name = var.virtual_machine_user_name
  virtual_machine_password  = var.virtual_machine_password

  virtual_machine_purpose      = var.virtual_machine_purpose


  virtual_machine_nic_name           = join("-", [local.virtual_machine_name, "nic1"])
  virtual_machine_nic_ip_config_name = join("-", [local.virtual_machine_name, "nic1", "config"])
  virtual_machine_public_ip_name     = join("-", [local.virtual_machine_name, "pip"])

  private_ip_allocation_method            = coalesce(var.private_ip_allocation_method, local.defaults.private_ip_allocation_method)
  private_ip_address                      = local.private_ip_allocation_method == "Dynamic" ? null : var.private_ip_address
  enable_accelerated_networking           = var.enable_accelerated_networking
  dns_servers                             = coalesce(var.dns_servers, local.defaults.dns_servers)
  load_balancer_backend_address_pools_ids = var.load_balancer_backend_address_pools_ids
  load_balancer_inbound_nat_rules_ids     = var.load_balancer_inbound_nat_rules_ids
  application_security_group_ids          = var.application_security_group_ids

  #Public IP
  public_ip_create            = var.public_ip_create
  public_ip_sku               = coalesce(var.public_ip_sku, local.defaults.public_ip_sku)
  public_ip_allocation_method = coalesce(var.public_ip_allocation_method, local.defaults.public_ip_allocation_method)

  #Azure OS Disk
  os_disk_size_gb               = var.os_disk_size_gb
  os_disk_storage_account_type  = coalesce(var.os_disk_storage_account_type, local.defaults.os_disk_storage_account_type)
  os_disk_caching               = coalesce(var.os_disk_caching, local.defaults.os_disk_caching)

  #Azure Data Disk
  data_disks                              = var.data_disks
  data_disk_default_caching               = coalesce(var.data_disk_default_caching, local.defaults.data_disk_default_caching)
  data_disk_default_create_option         = coalesce(var.data_disk_default_create_option, local.defaults.data_disk_default_create_option)
  data_disk_default_storage_account_type  = coalesce(var.data_disk_default_storage_account_type, local.defaults.data_disk_default_storage_account_type)
  data_disk_default_size_gb               = coalesce(var.data_disk_default_size_gb, local.defaults.data_disk_default_size_gb)

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

  # VM Custom Script Extension
  custom_script_enable = var.custom_script_enable
  custom_script_protected_settings = {
    "fileUris"         = var.custom_script_file_uris
    "commandToExecute" = var.custom_script_command
  }

  #Azure Disk Encryption
  encrypt_os_disk        = coalesce(var.encrypt_os_disk, local.defaults.encrypt_os_disk)
  encrypt_data_disk      = coalesce(var.encrypt_data_disk, local.defaults.encrypt_data_disk)
  encryption_settings    = var.encryption_settings
  encrypt_vm             = (local.encrypt_os_disk || local.encrypt_data_disk) && local.encryption_settings != null
  encryption_volume_type = ((local.encrypt_os_disk && local.encrypt_data_disk) ? "All" :
    (local.encrypt_os_disk && ! local.encrypt_data_disk) ? "OS" :
    (! local.encrypt_os_disk && local.encrypt_data_disk) ? "Data" : "")

  disk_encryption_set_id = var.disk_encryption_set_id

  # Domain Settings
  join_domain          = var.join_domain
  join_domain_settings = var.join_domain_settings

  # Azure Monitor Log Analytics Extension
  azure_monitor_agent_enable    = (var.azure_monitor_agent_settings != null)
  azure_monitor_agent_settings  = var.azure_monitor_agent_settings

  #Azure Backup
  enable_recovery_services_protection = var.recovery_services_protection_policy != null ? true : false
  recovery_services_protection_policy = var.recovery_services_protection_policy

  tags = merge(try(module.tags.tags, {}), try(var.tags, {}))
}
