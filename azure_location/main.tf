data "external" "azure_locations" {
  program = ["${path.module}/scripts/Get-AzureLocation.ps1"]

  query = {
    location  = var.location
  }
}