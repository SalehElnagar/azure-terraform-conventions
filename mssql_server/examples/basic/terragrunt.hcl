terraform {
  source = "../.."
}

inputs = {
  resource_group_name = "rg-weu-example-database-dev"
  location            = "westeurope"

  namespace    = "example"
  application  = "database"
  environment  = "development"
  purpose      = "mssql"

  azuread_administrator_object_id = "00000000-0000-0000-0000-000000000000"
}

