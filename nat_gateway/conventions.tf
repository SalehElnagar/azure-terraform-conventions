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
    purpose     = var.purpose
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

module "public_ip_prefix_name" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "PIPPrefix"
    location    = var.location
    namespace   = var.namespace
    purpose     = var.purpose
    attributes  = var.attributes
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

module "nat_gateway_name" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "NAT"
    location    = var.location
    namespace   = var.namespace
    purpose     = var.purpose
    attributes  = var.attributes
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
