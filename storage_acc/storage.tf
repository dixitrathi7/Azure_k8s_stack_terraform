data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "static_storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.rg_name
  location                 = var.region

  account_kind = "StorageV2"
  account_tier = "Standard"
  access_tier  = "Hot"

  account_replication_type = "LRS"

  shared_access_key_enabled       = false

  default_to_oauth_authentication = true

  # Security
  https_traffic_only_enabled       = true
  min_tls_version                  = "TLS1_2"
  cross_tenant_replication_enabled = false

  # Networking
  public_network_access_enabled = true

  # Encryption
  infrastructure_encryption_enabled = false

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action = "Deny"
    ip_rules       = [ "152.59.89.54" ]  # Replace with your IP
    bypass         = ["AzureServices"]    # Allow Azure services
  }

  static_website {
    index_document = "index.html"
    error_404_document = "404.html"
  }
}

resource "azurerm_role_assignment" "storage_blob_data_contributor" {
  scope                = azurerm_storage_account.static_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id

}

resource "azurerm_storage_blob" "index_html" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.static_storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "index.html"

  depends_on = [azurerm_role_assignment.storage_blob_data_contributor]
}

