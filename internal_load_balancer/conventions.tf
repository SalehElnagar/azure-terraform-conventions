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

module "lb_name" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "LB"
    location    = var.location
    namespace   = var.namespace
    purpose     = var.purpose
    attributes  = concat(var.attributes, ["INT"])
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
