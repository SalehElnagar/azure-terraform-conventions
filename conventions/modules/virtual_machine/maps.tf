module "common" {
  source = "../common"
}

locals {
  roles = {
    "workstation" = "ws"
    "server"      = "sv"
  }
}