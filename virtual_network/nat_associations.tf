locals {

  subnet_ids = []


}

resource "azurerm_subnet_nat_gateway_association" "subnets" {
  for_each = { for s in local.nat_gateway_subnets: s => module.virtual_network.subnets[s].id }

  nat_gateway_id = data.terraform_remote_state.nat.outputs.id
  subnet_id = each.value
}

# resource "azurerm_subnet_nat_gateway_association" "subnets1" {
#   subnet_id      = azurerm_subnet.example.id
#   nat_gateway_id = azurerm_nat_gateway.example.id
# }
# resource "azurerm_subnet_nat_gateway_association" "subnets2" {
#   subnet_id      = azurerm_subnet.example.id
#   nat_gateway_id = azurerm_nat_gateway.example.id
# }
# resource "azurerm_subnet_nat_gateway_association" "subnets3" {
#   subnet_id      = azurerm_subnet.example.id
#   nat_gateway_id = azurerm_nat_gateway.example.id
# }
# resource "azurerm_subnet_nat_gateway_association" "subnets4" {
#   subnet_id      = azurerm_subnet.example.id
#   nat_gateway_id = azurerm_nat_gateway.example.id
# }
# resource "azurerm_subnet_nat_gateway_association" "subnets5" {
#   subnet_id      = azurerm_subnet.example.id
#   nat_gateway_id = azurerm_nat_gateway.example.id
# }
# resource "azurerm_subnet_nat_gateway_association" "subnets6" {
#   subnet_id      = azurerm_subnet.example.id
#   nat_gateway_id = azurerm_nat_gateway.example.id
# }
