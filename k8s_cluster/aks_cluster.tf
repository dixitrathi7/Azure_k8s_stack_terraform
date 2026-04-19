data "azurerm_kubernetes_service_versions" "current" {
  location = var.region
}
/*
resource "azurerm_role_assignment" "keyvault_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}

resource "azurerm_role_assignment" "acr_pull_uami" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}

resource "azurerm_role_assignment" "acr_pull_uami_already" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
} 

resource "azurerm_role_assignment" "network_contributor" {
  scope                = var.vnet_ide
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}
*/
resource "azurerm_role_assignment" "aks_cluster" {
  scope                = var.rg_name_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_cluster.principal_id
}

resource "azurerm_role_assignment" "aks_worker" {
  scope                = var.rg_name_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_kubelet.principal_id
}


resource "azurerm_kubernetes_cluster" "main" {

  name                = "aks-${var.app_name}-${var.env_name}"
  location            = var.region
  resource_group_name = var.rg_name

  sku_tier                          = "Standard"
  kubernetes_version                = data.azurerm_kubernetes_service_versions.current.latest_version
  dns_prefix                        = "${var.app_name}-${var.env_name}"
  role_based_access_control_enabled = true  # allows Entra ID identities to be used inside k8s
  oidc_issuer_enabled               = true  # enables Entra ID SSO
  workload_identity_enabled         = true  # allows k8s resources to impersonate Entra ID identities
#  local_account_disabled            = false # allows GitHub Actions to use simple authN to manage k8s resources

  identity {
    type         = "UserAssigned"

    identity_ids = [azurerm_user_assigned_identity.aks_cluster.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks_kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.aks_kubelet.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet.id
  }

  # resource and security isolation for k8s system processes
  default_node_pool {
    name       = "npsystem"
    node_count = var.aks_configuration.system_pool.capacity
    vm_size    = var.aks_configuration.system_pool.sku
    os_sku     = "Mariner"
    vnet_subnet_id = var.private_subnet_1
    type       = "VirtualMachineScaleSets"
    zones      = [1, 2, 3]
  }

  network_profile {

    # Azure CNI overlay
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    pod_cidr            = "172.16.0.0/16"
    service_cidr        = "11.0.100.0/22"
    dns_service_ip      = "11.0.100.10"
    load_balancer_sku   = "standard"

    # No outbound_ip_address_ids needed; subnet's NAT Gateway will be used for egress

  }

  # maintenance windows
  maintenance_window_auto_upgrade {
    frequency   = "Weekly"
    interval    = 1
    duration    = 4
    day_of_week = "Friday"
    utc_offset  = "-05:00"
    start_time  = "20:00"
  }

  maintenance_window_node_os {
    frequency   = "Weekly"
    interval    = 1
    duration    = 4
    day_of_week = "Saturday"
    utc_offset  = "-05:00"
    start_time  = "20:00"
  }

  # adds KeyVault Secrets Provider
  key_vault_secrets_provider {
    secret_rotation_enabled  = false
    secret_rotation_interval = "2m"
  }


  # observability
  microsoft_defender {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  tags = {
    Project     = var.project_name
    Environment = var.env_name
    Owner       = var.user_name
    stack       = var.stack_name
  }
/*
  ingress_application_gateway {
    # gateway_id = azurerm_application_gateway.main.id
    subnet_id = var.app_gateway_subnet
  }*/


}

resource "azurerm_kubernetes_cluster_node_pool" "workload" {

  name                   = "npworkload"
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.main.id
  vm_size                = var.aks_configuration.workload_pool.sku
  enable_auto_scaling    = true
  os_sku                 = "Mariner"
  vnet_subnet_id         = var.private_subnet_1
  zones                  = [1, 2]
  node_count             = var.aks_configuration.workload_pool.capacity.ready
  min_count              = var.aks_configuration.workload_pool.capacity.min
  max_count              = var.aks_configuration.workload_pool.capacity.max

}
