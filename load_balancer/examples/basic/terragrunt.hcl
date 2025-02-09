terraform {
  source = "../.."
}

inputs = {
  resource_group_name = "rg-weu-example-network-dev"
  name        = null
  namespace   = "example"
  application = "network"
  environment = "development"
  purpose     = "lb"
}

