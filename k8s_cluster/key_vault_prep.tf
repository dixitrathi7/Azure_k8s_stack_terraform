

resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.rg_name
  depends_on = [ azurerm_log_analytics_workspace.main ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_workload" {
  name                  = "dns-link-keyvault-workload"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = var.vnet_ide

  depends_on = [ azurerm_private_dns_zone.keyvault ]
}

resource "azurerm_private_endpoint" "keyvault" {
  name                = "pep-${azurerm_key_vault.main.name}"
  resource_group_name = var.rg_name
  location            = var.region
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${azurerm_key_vault.main.name}-link"
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "vault-dns"
    private_dns_zone_ids = [azurerm_private_dns_zone.keyvault.id]
  }

  depends_on = [ azurerm_key_vault.main, azurerm_private_dns_zone.keyvault ]
}