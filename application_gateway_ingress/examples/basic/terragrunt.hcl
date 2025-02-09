terraform {
  source = "../.."
}

inputs = {
  location     = "westeurope"
  storageName  = "tfstateweu"
  key          = "agic/terraform.tfstate"

  namespace    = "example"
  application  = "core"
  environment  = "development"
  purpose      = "agic"

  standardize_resource_group = false
  standardize_resources      = true
  include_environment        = true
}

