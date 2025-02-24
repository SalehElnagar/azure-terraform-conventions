provider "azurerm" {
  features {}
  tenant_id       = "0434a006-8416-4f37-ac76-7faba181cc04"
  subscription_id = "39183843-4817-43e7-ac4b-f1184972e3e7"
  client_id       = "a7038e2a-cbc2-4399-8967-7e0afb8dc681"
  client_secret   = "JDpz1e9TkC096k-QOY0PqlITIFuKTnIB_N"
  alias           = "dev"
}

provider "azurerm" {
  features {}
  tenant_id       = "0434a006-8416-4f37-ac76-7faba181cc04"
  subscription_id = "4bd941bd-7347-46f3-a2a5-488e5d75128f"
  client_id       = "91b7655b-2372-4d68-a248-ff986ec34f15"
  client_secret   = "c3-WaEz5D9_g7NTuogUynxnBH~QkAPGlq1"
  alias           = "stg"
}
