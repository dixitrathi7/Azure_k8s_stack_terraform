output "vnet_ide" {
  description = "VNet id"
  value       = azurerm_virtual_network.tofu_vnet.id
}

output "subnet_ids" {
  description = "Subnet IDs"
  value = {
    public_subnet_1               = azurerm_subnet.public_subnet_1.id
    public_subnet_2               = azurerm_subnet.public_subnet_2.id
    app_gateway_subnet            = azurerm_subnet.public_app_gateway_subnet.id
    private_subnet_1              = azurerm_subnet.private_subnet_1.id
    private_subnet_2              = azurerm_subnet.private_subnet_2.id
    private_endpoint_subnet       = azurerm_subnet.private_endpoint_subnet.id
  }
}


output "nat_gateway_public_ip" {
  description = "Public IP used for outbound by NAT Gateway"
  value       = azurerm_public_ip.nat_pip.ip_address
}

# If using prefix:
output "nat_gateway_public_ip_from_prefix" {
  value = azurerm_public_ip.nat_pip.ip_address
}


output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = azurerm_nat_gateway.nat_gw.id
}