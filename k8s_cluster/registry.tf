

resource "azurerm_container_registry" "main" {
  name                          = "cr${var.app_name}${var.env_name}"
  resource_group_name           = var.rg_name
  location                      = var.region
  sku                           = "Premium"
  zone_redundancy_enabled       = true
  admin_enabled                 = true
  data_endpoint_enabled         = false
  public_network_access_enabled = true
  network_rule_bypass_option    = "AzureServices"

  network_rule_set {
    default_action = "Allow"

   /* ip_rule {
      action   = "Allow"
      ip_range = "20.40.50.1/32" # Replace with your actual IP/32
      # Use /32 for a single IP, e.g., "203.0.113.10/32"
      # Use /24 for a range, e.g., "203.0.113.0/24"
    }*/
  }

  tags = {
    Project     = var.project_name
    Environment = var.env_name
    Owner       = var.user_name
    stack       = var.stack_name
  }

}

