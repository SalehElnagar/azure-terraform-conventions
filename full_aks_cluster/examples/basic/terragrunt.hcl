terraform {
  source = "../.."
}

inputs = {
  location     = "westeurope"
  storageName  = "tfstateweu"
  key          = "aks/terraform.tfstate"

  namespace    = "example"
  application  = "core"
  environment  = "development"
  purpose      = "aks"
  dns_prefix   = "aks-dev"

  # Optional inputs shown for clarity
  standardize_resource_group = false
  standardize_resources      = true
  include_environment        = true
}

