
# ==================common variables for all modules( resource group $ container registry) ==================

rg_name = "zoho-improzo-poc"

project_name = "zohotofu"
app_name = "zohobackend"
env_name = "backend"
user_name = "Dixit"
stack_name = "POC"

region = "centralindia"

your_ip_address = "152.59.89.54"

vnet_address_cidr = "11.0.0.0/16"

subnets_cidr = {
  public_subnet_1_cidr = "11.0.1.0/24"
  public_subnet_2_cidr  = "11.0.2.0/24"
  app_gateway_subnet_cidr = "11.0.3.0/24"
  private_subnet_1_cidr = "11.0.11.0/24"
  private_subnet_2_cidr = "11.0.12.0/24"
  private_endpoint_subnet_cidr = "11.0.14.0/24"
  
}



storage_account_name = "tofustaticstorage632"

app_gateway_configuration = {
  sku = "Standard_v2"
  capacity = {
    ready = 1
    min   = 1
    max   = 125
  }
}

aks_configuration = {
  system_pool = {
    sku      = "Standard_D4s_v3"
    capacity = 1
  }
  workload_pool = {
    sku = "Standard_D4s_v3"
    capacity = {
      ready = 1
      min   = 1
      max   = 2
    }
  }
}


k8s_namespace = "test"
k8s_service_account_name = "zoho-service-account"      # this mandatory service account will be created in the namespace

kubernetes_version = "1.33.5"

node_vm_size = "Standard_D4s_v3"
