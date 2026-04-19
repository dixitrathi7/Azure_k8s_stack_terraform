
/*
resource "azurerm_public_ip" "app_gateway" {
  name                = "pip-agw-${var.app_name}-${var.env_name}"
  location            = var.region
  resource_group_name = var.rg_name

  sku                     = "Standard"
  zones                   = [1, 2, 3]
  allocation_method       = "Static"
  idle_timeout_in_minutes = 4
  domain_name_label       = "agw-${var.app_name}-${var.env_name}"

  depends_on = [ azurerm_log_analytics_workspace.main ]
  
}

resource "azurerm_user_assigned_identity" "agic_identity" {
  name                = "user-mi-agic-${var.app_name}-${var.env_name}"
  resource_group_name = var.rg_name
  location            = var.region
}

locals {
#  backend_ip_address = cidrhost(var.subnets_cidr.app_gateway_subnet_cidr, 200)

  backend_address_pool_name      = "myBackendPool"
  frontend_ip_configuration_name = "appGwPublicFrontendIp"
  backend_http_settings_name     = "healthCheckSettings"
  frontend_port_name            = "appGwFrontendPort"
  listener_name                  = "appGwHttpListener"
  probe_name                     = "healthCheck"
  url_path_map_name              = "httpRule"
  http_listener_name             = "httpListener"
  request_routing_rule_name      = "rule1"
}



resource "azurerm_application_gateway" "main" {
  name                = "appgateway-${var.app_name}-${var.env_name}"
  resource_group_name = var.rg_name
  location            = var.region

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.appgw.id]
  }


  sku {
    name     = var.app_gateway_configuration.sku
    tier     = var.app_gateway_configuration.sku
   # capacity = var.app_gateway_configuration.capacity.min
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  zones        = [1, 2, 3]
 # enable_http2 = false

  autoscale_configuration {
    min_capacity = var.app_gateway_configuration.capacity.min
    max_capacity = var.app_gateway_configuration.capacity.max
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.app_gateway_subnet
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_settings_name
  }
}

resource "azurerm_role_assignment" "agic_appgw_contributor" {
  scope                = azurerm_application_gateway.main.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.agic_identity.principal_id
}

resource "azurerm_role_assignment" "agic_aks_reader" {
  scope                = azurerm_kubernetes_cluster.main.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}

resource "azurerm_role_assignment" "agic_subnet_network" {
  scope                = var.app_gateway_subnet
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.agic_identity.principal_id
}
*/