data "azurerm_client_config" "current" {}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.app_name}-${var.env_name}"
  location            = var.region
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

/*
resource "azurerm_key_vault_access_policy" "terraform_access" {
  key_vault_id = azurerm_key_vault.main.id
  
  # Use your service principal/client ID or current user
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id  # Current user/service principal
  key_permissions = [
    "Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore",
    "Recover", "Purge", "UnwrapKey", "WrapKey", "Verify", "Sign", "Encrypt", "Decrypt"
  ]
  
  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]
  
  certificate_permissions = [
    "Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore",
    "Recover", "Purge", "ManageContacts", "ManageIssuers", "GetIssuers",
    "ListIssuers", "SetIssuers", "DeleteIssuers"
  ]
  
  storage_permissions = [
    "Get", "List", "Delete", "Set", "Update", "RegenerateKey", "Recover",
    "Purge", "Backup", "Restore", "SetSAS", "ListSAS", "GetSAS", "DeleteSAS"
  ]
}
*/
/*
resource "azurerm_key_vault_secret" "app_insights_instrumentation_key" {
  key_vault_id = azurerm_key_vault.main.id
  name         = "app-insights-connection-string"
  value        = azurerm_application_insights.main.connection_string

  depends_on = [ 
    azurerm_key_vault.main,
    azurerm_key_vault_access_policy.terraform_access  # Add this dependency
  ]
}

resource "azurerm_role_assignment" "kv_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}
*/