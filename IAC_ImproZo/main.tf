

data "azurerm_client_config" "current" {}

locals {
  tenant_id = data.azurerm_client_config.current.tenant_id
}

# -------------------------------
# Resource Group
# -------------------------------
resource "azurerm_resource_group" "tofu_rg" {
  name     = var.rg_name
  location = var.region
}


module "vnet_module" {
  source     = "./vnet"
  rg_name    = azurerm_resource_group.tofu_rg.name
  region     = var.region

  project_name = var.project_name
  app_name     = var.app_name
  env_name     = var.env_name
  user_name    = var.user_name
  stack_name   = var.stack_name

  vnet_address_cidr = var.vnet_address_cidr
  subnets_cidr      = var.subnets_cidr
}
/*
module "storage_account_module" {
  source     = "./storage_acc"

  rg_name    = azurerm_resource_group.tofu_rg.name
  region     = var.region
  vnet_ide   = module.vnet_module.vnet_ide
  private_endpoint_subnet_id = module.vnet_module.subnet_ids["private_endpoint_subnet"]

  storage_account_name = var.storage_account_name
  project_name = var.project_name
  app_name     = var.app_name
  env_name     = var.env_name
  user_name    = var.user_name
  stack_name   = var.stack_name
  your_ip_address = var.your_ip_address

  depends_on = [ module.vnet_module ]
  
}
*/
module "aks_module" {
  source     = "./own_aks"
  rg_name    = azurerm_resource_group.tofu_rg.name
  rg_name_id = azurerm_resource_group.tofu_rg.id
  region     = var.region


  project_name = var.project_name
  app_name     = var.app_name
  env_name     = var.env_name
  user_name    = var.user_name
  stack_name   = var.stack_name

  k8s_namespace = var.k8s_namespace
 # admin_groups = var.admin_groups
  aks_configuration = var.aks_configuration
  k8s_service_account_name = var.k8s_service_account_name
  kubernetes_version = var.kubernetes_version
  node_vm_size = var.node_vm_size

  subnets_cidr      = var.subnets_cidr
  vnet_ide        = module.vnet_module.vnet_ide
  public_subnet_1 = module.vnet_module.subnet_ids["public_subnet_1"]
  public_subnet_2 = module.vnet_module.subnet_ids["public_subnet_2"]
  app_gateway_subnet = module.vnet_module.subnet_ids["app_gateway_subnet"]
  private_subnet_1 = module.vnet_module.subnet_ids["private_subnet_1"]
  private_subnet_2 = module.vnet_module.subnet_ids["private_subnet_2"]
  private_endpoint_subnet_id = module.vnet_module.subnet_ids["private_endpoint_subnet"]

  app_gateway_configuration = var.app_gateway_configuration

  depends_on = [ module.vnet_module ]

}
/*

module "front_door_cdn_module" {
  source     = "./front_door_cdn"

  rg_name    = var.rg_name
  region     = var.region

  project_name = var.project_name
  app_name     = var.app_name
  env_name     = var.env_name
  user_name    = var.user_name
  stack_name   = var.stack_name

  app_gateway_public_ip = module.aks_module.app_gateway_public_ip
  static_storage_account_id = module.storage_account_module.static_storage_account_id
  storage_account_host_name = module.storage_account_module.storage_account_host_name

}
*/
