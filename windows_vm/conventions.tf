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

module "vm_name" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "vm"
    location    = var.location
    namespace   = var.namespace
    purpose     = var.virtual_machine_purpose
    attributes  = var.attributes
    environment = var.environment
  }

  options = {
    delimiter           = "-"
    standardize         = true
    include_environment = true
  }

  tags = {
    include_generated = true
    additional        = try(var.tags, {})
  }
}

