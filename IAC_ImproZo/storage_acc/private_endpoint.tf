resource "azurerm_private_endpoint" "storage_web_perivate_endpoint" {
  name                = "${var.project_name}-private-endpoint-web"
  location            = var.region
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.project_name}-private-connection-web"
    private_connection_resource_id = azurerm_storage_account.static_storage_account.id
    subresource_names              = ["web"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.project_name}-web-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_web_dns.id]
  }
  depends_on = [ azurerm_private_dns_zone_virtual_network_link.web_dns_link ]
}


#================================================================================================

resource "azurerm_private_endpoint" "front_door_perivate_endpoint" {
  name                = "pe-${var.storage_account_name}-cdn-endpoint"
  location            = var.region
  resource_group_name = var.rg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${var.storage_account_name}-blob"
    private_connection_resource_id = azurerm_storage_account.static_storage_account.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone" "cdn_private_dns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_dns_link" {
  name                  = "blob-dns-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.cdn_private_dns.name
  virtual_network_id   = var.vnet_ide
}
