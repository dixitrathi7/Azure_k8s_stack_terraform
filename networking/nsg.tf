# -------------------------------
# NSG: Public subnets
# Allow inbound from Internet on ANY port
# -------------------------------
resource "azurerm_network_security_group" "nsg_public" {
  name                = "${var.project_name}-nsg-public"
  location            = var.region
  resource_group_name = var.rg_name

  tags = {
    "Project"     = var.project_name
    "Application" = var.app_name
    "ENV"         = var.env_name
    "STACK"       = var.stack_name
    "Created-by"  = var.user_name
  }

  # Allow all inbound from Internet
  security_rule {
  name                       = "Allow-Internet-Inbound-All"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "Internet"
  destination_address_prefix = "*"
}

security_rule {
  name                       = "Allow-Internet-Outbound-All"
  priority                   = 200   # changed
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "*"
  destination_address_prefix = "Internet"
}

}

# -------------------------------
# NSG: Private subnets
# Allow inbound ONLY from within the VNet (local traffic), deny Internet
# -------------------------------
resource "azurerm_network_security_group" "nsg_private" {
  name                = "${var.project_name}-nsg-private"
  location            = var.region
  resource_group_name = var.rg_name

  tags = {
    Project     = var.project_name
    Application = var.app_name
    ENV         = var.env_name
    STACK       = var.stack_name
    Created-by  = var.user_name
  }

  # Allow inbound ONLY from within the VNet
  security_rule {
    name                       = "AllowVNetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Allow outbound Internet (via NAT)
  security_rule {
    name                       = "AllowOutboundInternet"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}



resource "azurerm_route_table" "private_rt" {
  name                = "private-rt"
  location            = var.region
  resource_group_name = var.rg_name
}

# Route all internet-bound traffic to NAT Gateway
resource "azurerm_route" "private_internet_route" {
  name                   = "default-internet-route"
  resource_group_name    = var.rg_name
  route_table_name       = azurerm_route_table.private_rt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "Internet"  # NAT Gateway handles the translation
}

# Associate route table to private subnets
resource "azurerm_subnet_route_table_association" "private_assoc_subnet1" {
  subnet_id      = azurerm_subnet.private_subnet_1.id
  route_table_id = azurerm_route_table.private_rt.id
}

resource "azurerm_subnet_route_table_association" "private_assoc_sebnet2" {
  subnet_id      = azurerm_subnet.private_subnet_2.id
  route_table_id = azurerm_route_table.private_rt.id
}

resource "azurerm_subnet_route_table_association" "private_assoc_subnet3" {
  subnet_id      = azurerm_subnet.private_endpoint_subnet.id
  route_table_id = azurerm_route_table.private_rt.id
}

