
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  subscription_id = "d0d107c0-20c4-417c-b411-af14c15893af"
  storage_use_azuread = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

    key_vault {
      # Remove `purge_protection_enabled = true` from here. It must be set on the `azurerm_key_vault` resource itself.
      purge_soft_delete_on_destroy = true # or false, based on your policy
    }
  }
}

/*
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.k8s.oidc_issuer_url
    client_certificate     = azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate
    client_key             = azurerm_kubernetes_cluster.k8s.kube_config[0].client_key
    cluster_ca_certificate = azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
  }
}*/
