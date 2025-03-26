terraform {
  source = "../.."
}

inputs = {
  storage_account_name = "tfstateweu"
  container_name       = "tfstate"
  key                  = "example/terraform.tfstate"
  resource_group_name  = "rg-weu-tfstate"
}

