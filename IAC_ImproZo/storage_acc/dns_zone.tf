resource "azurerm_private_dns_zone" "private_web_dns" {
  name                = "privatelink.web.core.windows.net"
  resource_group_name = var.rg_name

  depends_on = [ azurerm_storage_account.static_storage_account ]
}


resource "azurerm_private_dns_zone_virtual_network_link" "web_dns_link" {
  name                  = "${var.project_name}-private-dns-web-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.private_web_dns.name
  virtual_network_id    = var.vnet_ide

  depends_on = [ azurerm_private_dns_zone.private_web_dns ]
}