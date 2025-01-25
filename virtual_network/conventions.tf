locals {
  conventions_root = "../conventions/modules"
}

module "tags" {
  source = "${local.conventions_root}/tags"

  metadata = {
    namespace   = var.namespace
    application = var.application
    environment = var.environment
    additional  = try(var.tags, {})
  }
}

module "resource_group_name" {
  source = "${local.conventions_root}/resource_group"

  naming = {
    location    = var.location
    namespace   = var.namespace
    purpose     = var.resource_group_purpose
    attributes  = var.resource_group_attributes
    environment = var.environment
  }

  options = {
    standardize         = var.standardize_resource_group
    include_environment = var.include_environment
  }

  tags = {
    include_generated = true
    additional        = try(var.tags, {})
  }

}

module "virtual_network_name" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "VN"
    location    = var.location
    namespace   = var.namespace
    purpose     = var.resource_group_purpose
    attributes  = var.resource_group_attributes
    environment = var.environment
  }

  options = {
    delimiter           = "-"
    standardize         = var.standardize_resources
    include_environment = var.include_environment
  }

  tags = {
    include_generated = true
    additional        = try(var.tags, {})
  }
}

module "storage_account_name" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "sa"
    location    = var.location
    namespace   = var.namespace
    purpose     = "nsg"
    attributes  = var.storage_account_attributes
    environment = var.environment
  }

  options = {
    delimiter           = ""
    standardize         = true
    include_environment = var.include_environment
  }

  tags = {
    include_generated = true
    additional        = try(var.tags, {})
  }
}

module "route_table_components" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "RT"
    location    = var.location
    namespace   = var.namespace
    purpose     = ""
    attributes  = []
    environment = var.environment
  }

  options = {
    delimiter           = "-"
    standardize         = false
    include_environment = var.include_environment
    split_on_label      = "attributes"
  }

  tags = {
    include_generated = true
    additional        = try(var.tags, {})
  }
}

module "internal_network_security_group_components" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "NSG"
    location    = var.location
    namespace   = var.namespace
    purpose     = "INT"
    attributes  = []
    environment = var.environment
  }

  options = {
    delimiter           = "-"
    standardize         = false
    include_environment = var.include_environment
    split_on_label      = "attributes"
  }

  tags = {
    include_generated = true
    additional        = try(var.tags, {})
  }
}

module "external_network_security_group_components" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "NSG"
    location    = var.location
    namespace   = var.namespace
    purpose     = "EXT"
    attributes  = []
    environment = var.environment
  }

  options = {
    delimiter           = "-"
    standardize         = false
    include_environment = var.include_environment
    split_on_label      = "attributes"
  }

  tags = {
    include_generated = true
    additional        = try(var.tags, {})
  }
}
