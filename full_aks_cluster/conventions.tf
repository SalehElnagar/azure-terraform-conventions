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
    attributes  = var.attributes
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

module "node_resource_group_name" {
  source = "${local.conventions_root}/resource_group"

  naming = {
    location    = var.location
    namespace   = var.namespace
    purpose     = var.purpose
    attributes  = concat(var.attributes, ["Node"])
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

module "aks_cluster_name" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "AKS"
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

module "log_analytics_workspace_name" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "LAW"
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

module "key_vault_name" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "kv"
    location    = var.location
    namespace   = "core"
    purpose     = "aks"
    attributes  = []
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

module "disk_encryption_set_name" {
  source = "${local.conventions_root}/resource"

  naming = {
    prefix      = "DES"
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
