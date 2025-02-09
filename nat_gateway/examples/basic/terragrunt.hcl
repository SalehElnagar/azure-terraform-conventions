terraform {
  source = "../.."
}

inputs = {
  location     = "westeurope"
  namespace    = "example"
  application  = "core"
  environment  = "development"
  purpose      = "nat"

  # Optional inputs
  zones                    = []
  idle_timeout_in_minutes  = 10
  standardize_resource_group = false
  standardize_resources      = true
  include_environment        = true
}

