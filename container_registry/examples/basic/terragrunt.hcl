terraform {
  source = "../.."
}

inputs = {
  location     = "westeurope"
  namespace    = "example"
  application  = "containers"
  environment  = "development"
  purpose      = "acr"

  container_registry_purpose   = "registry"
  resource_group_attributes    = ["infra"]
  container_registry_attributes = ["core"]

  standardize_resource_group = false
  standardize_resources      = true
  include_environment        = true
}

