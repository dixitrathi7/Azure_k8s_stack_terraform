variable "rg_name" {
    type = string
    default = "Defautl-tofu-RG"
}

variable "rg_name_id" {
  type = string
}
variable "region" {
  type = string
  default = "centralindia"
}

variable "project_name" {
  type = string
  default = "tofuproject"
}

variable "app_name" {
  type = string
  default = "tofuapp"
}

variable "env_name" {
  type = string
  default = "tofuenv"
}

variable "user_name" {
  type = string
  default = "tofuuser"
}
variable "stack_name" {
  type = string
  default = "tofustack"
}

variable "kubernetes_version" {
  type = string 
}

variable "node_vm_size" {
  type = string
  default = "Standard_D8ds_v5"
}

variable "subnets_cidr" {
  description = "Subnet CIDR blocks"
  type = object({
    public_subnet_1_cidr  = string
    public_subnet_2_cidr  = string
    private_subnet_1_cidr = string
    private_subnet_2_cidr = string
    private_endpoint_subnet_cidr = string
    app_gateway_subnet_cidr = string
  })
}

variable "private_subnet_1" {
  description = "Subnet ID for AKS system node pool"
  type        = string
}

variable "private_subnet_2" {
  description = "Subnet ID for AKS user node pool"
  type        = string
}

variable "public_subnet_1" {
  description = "Subnet ID for public access"
  type        = string
}

variable "public_subnet_2" {
  description = "Subnet ID for public access"
  type        = string
}

variable "app_gateway_subnet" {
  description = "Subnet ID for Application Gateway"
  type        = string
}

variable "private_endpoint_subnet_id" {
  type = string
}

variable "vnet_ide" {
  type = string
}

variable "storage_account_name" {
  type = string
  default = "tofustaticstorage632"
}

variable "app_gateway_configuration" {
  type = object({
    sku = string
    capacity = object({
      ready = number
      min   = number
      max   = number
    })
  })
}

variable "aks_configuration" {
  type = object({
    system_pool = object({
      sku      = string
      capacity = number
    })
    workload_pool = object({
      sku = string
      capacity = object({
        ready = number
        min   = number
        max   = number
      })
    })
  })
}

/*variable "admin_groups" {
  type = list(string)
}
*/
variable "k8s_namespace" {
  type = string
}

variable "k8s_service_account_name" {
  type = string
}