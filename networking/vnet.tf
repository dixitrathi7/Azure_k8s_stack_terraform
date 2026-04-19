
#--------------------------------------------
# Ddos protection plan - Default is "false"
#--------------------------------------------

/*resource "azurerm_network_ddos_protection_plan" "tofu_ddos_plan" {
name                = "${var.project_name}-ddos-plan"
location            = var.region
resource_group_name = var.rg_name


tags = {
    "Project"     = var.project_name
    "Application" = var.app_name
    "ENV"         = var.env_name
    "STACK"       = var.stack_name
    "Created-by"  = var.user_name
  }
}
*/

# -------------------------------
# VNet
# -------------------------------
resource "azurerm_virtual_network" "tofu_vnet" {
  name                = "${var.project_name}-vnet"
  location            = var.region
  resource_group_name = var.rg_name
  address_space       = [var.vnet_address_cidr]

 /* dynamic "ddos_protection_plan" {
    for_each = [1]
    content {
      id     = azurerm_network_ddos_protection_plan.tofu_ddos_plan.id
      enable = true
    }
  }*/
  
  tags = {
    "Project"     = var.project_name
    "Application" = var.app_name
    "ENV"         = var.env_name
    "STACK"       = var.stack_name
    "Created-by"  = var.user_name
  }

}


# -------------------------------
# Subnets
# -------------------------------
resource "azurerm_subnet" "public_subnet_1" {
  name                 = "${var.project_name}-subnet-public-a"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.tofu_vnet.name
  address_prefixes     = [var.subnets_cidr.public_subnet_1_cidr]

  depends_on = [ azurerm_virtual_network.tofu_vnet ]
}

resource "azurerm_subnet" "public_subnet_2" {
  name                 = "${var.project_name}-subnet-public-b"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.tofu_vnet.name
  address_prefixes     = [var.subnets_cidr.public_subnet_2_cidr]

  depends_on = [ azurerm_virtual_network.tofu_vnet ]
}

resource "azurerm_subnet" "private_subnet_1" {
  name                 = "${var.project_name}-subnet-private-a"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.tofu_vnet.name
  address_prefixes     = [var.subnets_cidr.private_subnet_1_cidr]

  depends_on = [ azurerm_virtual_network.tofu_vnet ]
}

resource "azurerm_subnet" "private_subnet_2" {
  name                 = "${var.project_name}-subnet-private-b"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.tofu_vnet.name
  address_prefixes     = [var.subnets_cidr.private_subnet_2_cidr]

  depends_on = [ azurerm_virtual_network.tofu_vnet ]
}

resource "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "${var.project_name}-subnet-private-endpoint"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.tofu_vnet.name
  address_prefixes     = [var.subnets_cidr.private_endpoint_subnet_cidr]

  depends_on = [ azurerm_virtual_network.tofu_vnet ]
}

resource "azurerm_subnet" "public_app_gateway_subnet" {
  name                 = "${var.project_name}-subnet-app-gateway"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.tofu_vnet.name
  address_prefixes     = [var.subnets_cidr.app_gateway_subnet_cidr]

  depends_on = [ azurerm_virtual_network.tofu_vnet ]
}

# -------------------------------
# Associate NSGs to subnets
# -------------------------------
resource "azurerm_subnet_network_security_group_association" "assoc_public_subnet_1" {
  subnet_id                 = azurerm_subnet.public_subnet_1.id
  network_security_group_id = azurerm_network_security_group.nsg_public.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_public_subnet_2" {
  subnet_id                 = azurerm_subnet.public_subnet_2.id
  network_security_group_id = azurerm_network_security_group.nsg_public.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_private_subnet_1" {
  subnet_id                 = azurerm_subnet.private_subnet_1.id
  network_security_group_id = azurerm_network_security_group.nsg_private.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_private_subnet_2" {
  subnet_id                 = azurerm_subnet.private_subnet_2.id
  network_security_group_id = azurerm_network_security_group.nsg_private.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_private_subnet_private_endpoint" {
  subnet_id                 = azurerm_subnet.private_endpoint_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_private.id
}

resource "azurerm_subnet_network_security_group_association" "assoc_app_gateway_subnet" {
  subnet_id                 = azurerm_subnet.public_app_gateway_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_public.id
}