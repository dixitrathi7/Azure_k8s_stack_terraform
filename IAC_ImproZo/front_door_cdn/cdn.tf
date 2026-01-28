resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = "${var.project_name}-cdn-profile"
  resource_group_name = var.rg_name
  sku_name            = "Premium_AzureFrontDoor"
  response_timeout_seconds = 90
}

resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = "${var.project_name}-cdn-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

# Origin Group for Storage Account (Static Content)
resource "azurerm_cdn_frontdoor_origin_group" "storage_origin_group" {
  name                     = "${var.project_name}-storage-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  session_affinity_enabled = false

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"  # Changed from GET to HEAD for health checks
    protocol            = "Https"
    interval_in_seconds = 120
  }
}

# Origin Group for App Gateway (API)
resource "azurerm_cdn_frontdoor_origin_group" "agw_origin_group" {
  name                     = "${var.project_name}-agw-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  session_affinity_enabled = false

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/api/HealthCheck/healthz/ready"  # App Gateway health check path
    request_type        = "GET"
    protocol            = "Http"
    interval_in_seconds = 120
  }
}

# Storage Account Origin
resource "azurerm_cdn_frontdoor_origin" "storage_origin" {
  name                          = "${var.project_name}-storage-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.storage_origin_group.id
  host_name                     = var.storage_account_host_name
  origin_host_header            = var.storage_account_host_name

  enabled                       = true
  http_port                     = 80
  https_port                    = 443
  priority                      = 1
  weight                        = 1000
  certificate_name_check_enabled = true

  # Private Link configuration (if storage account is private)
  # Remove this block if storage account is publicly accessible
  private_link {
    request_message        = "Request access for CDN FrontDoor"
    target_type            = "web"
    location               = var.region
    private_link_target_id = var.static_storage_account_id
    
  }
}

# App Gateway Origin (FIXED: Removed duplicate)
resource "azurerm_cdn_frontdoor_origin" "agw_origin" {
  name                          = "${var.project_name}-agw-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.agw_origin_group.id
  enabled                       = true
  host_name                     = var.app_gateway_public_ip  # Should be IP or FQDN
  origin_host_header            = var.app_gateway_public_ip  # Should be IP or FQDN
  http_port                     = 80
  https_port                    = 443
  priority                      = 1
  weight                        = 1000
  certificate_name_check_enabled = false  # Set to false if using IP address
}

# Default Route (catches everything)
resource "azurerm_cdn_frontdoor_route" "default_route" {
  name                          = "${var.project_name}-default-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.storage_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.storage_origin.id]
  
  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  link_to_default_domain = true
  
  cache {
    query_string_caching_behavior = "IgnoreQueryString"
    compression_enabled           = true
    content_types_to_compress     = ["text/html", "text/css", "text/javascript", "application/javascript"]
  }
}

resource "azurerm_cdn_frontdoor_route" "static_route" {
  name                          = "${var.project_name}-static-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.storage_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.storage_origin.id]
  
  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/static/*"]
  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  
  cache {
    query_string_caching_behavior = "IgnoreQueryString"
    compression_enabled           = true
    content_types_to_compress     = ["text/html", "text/css", "text/javascript", "application/javascript", "application/json", "image/svg+xml"]
  }
}

# API Route (routes API requests to App Gateway)
resource "azurerm_cdn_frontdoor_route" "api_route" {
  name                          = "${var.project_name}-api-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.agw_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.agw_origin.id]
  
  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/api/*"]
  forwarding_protocol    = "MatchRequest"
  https_redirect_enabled = true
  
  cache {
    query_string_caching_behavior = "IgnoreQueryString"
    compression_enabled           = false  # Usually disable for API
  }
}

# Health Check Route (for monitoring)
resource "azurerm_cdn_frontdoor_route" "health_route" {
  name                          = "${var.project_name}-health-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.agw_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.agw_origin.id]
  
  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/api/HealthCheck/*"]
  forwarding_protocol    = "HttpOnly"  # Health checks often use HTTP
  https_redirect_enabled = false
}