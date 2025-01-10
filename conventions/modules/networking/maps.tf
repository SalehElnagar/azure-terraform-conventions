module "common" {
  source = "../common"
}

locals {
  network_boundaries = {
    "internal" = "INT"
    "external" = "EXT"
  }
}

