data "external" "az_cloud" {
  program = ["bash", "-File", "${path.module}/scripts/Get-AzureCloud.sh"]
}

output "name" {
  value = data.external.az_cloud.result.name
}
