
resource "azurerm_user_assigned_identity" "workload" {
  location            = var.region
  resource_group_name = var.rg_name
  name                = "user-assigned-identity-${var.app_name}-${var.env_name}"
}
resource "azurerm_federated_identity_credential" "workload" {
  name                = azurerm_user_assigned_identity.workload.name
  resource_group_name = var.rg_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.main.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.workload.id
  subject             = "system:serviceaccount:${var.k8s_namespace}:${var.k8s_service_account_name}"

}

resource "azurerm_user_assigned_identity" "aks_cluster" {
  location            = var.region
  resource_group_name = var.rg_name
  name                = "aks-controlplane-${var.app_name}-${var.env_name}"
}

resource "azurerm_user_assigned_identity" "aks_kubelet" {
  location            = var.region
  resource_group_name = var.rg_name
  name                = "aks-kubelet-worker-${var.app_name}-${var.env_name}"
}