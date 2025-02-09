output "id" {
  value       = azurerm_nat_gateway.nat.id
  description = "The NAT Gateway Id."
}

# output "public_ip_prefix" {
#   value       = azurerm_public_ip_prefix.nat.ip_prefix
#   description = "The IP address prefix allocated to the NAT Gateway"
# }