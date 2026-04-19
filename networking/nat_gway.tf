
############################################################
# Public IP for NAT Gateway (Static, Standard)
############################################################
resource "azurerm_public_ip" "nat_pip" {
  name                = "${var.project_name}-nat-pip"
  resource_group_name = var.rg_name
  location            = var.region

  
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

 # ddos_protection_mode = "VirtualNetworkInherited"

  tags = {
    "Project"     = var.project_name
    "Application" = var.app_name
    "ENV"         = var.env_name
    "STACK"       = var.stack_name
    "Created-by"  = var.user_name
  }
  depends_on = [ azurerm_virtual_network.tofu_vnet ]
}

############################################################
# NAT Gateway
############################################################
resource "azurerm_nat_gateway" "nat_gw" {
  name                = "${var.project_name}-nat-gw"
  resource_group_name = var.rg_name
  location            = var.region

  sku_name            = "Standard" # NAT Gateway only supports Standard
  idle_timeout_in_minutes = 4 

  tags = {
    "Project"     = var.project_name
    "Application" = var.app_name
    "ENV"         = var.env_name
    "STACK"       = var.stack_name
    "Created-by"  = var.user_name
  }
}

############################################################
# Attach Public IP to NAT Gateway
############################################################
resource "azurerm_nat_gateway_public_ip_association" "nat_gw_pip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id

  depends_on = [ azurerm_public_ip.nat_pip , azurerm_nat_gateway.nat_gw ]
}

############################################################
# Associate NAT Gateway with Private Subnets
############################################################
resource "azurerm_subnet_nat_gateway_association" "private_a_assoc" {
  subnet_id      = azurerm_subnet.private_subnet_1.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}

resource "azurerm_subnet_nat_gateway_association" "private_b_assoc" {
  subnet_id      = azurerm_subnet.private_subnet_2.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}
