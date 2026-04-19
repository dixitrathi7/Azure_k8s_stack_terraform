variable "rg_name" {
    type = string
    default = "Defautl-tofu-RG"
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

variable "vnet_address_cidr" {
  type = string
  default = "10.0.0.0/16"
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


variable "create_ddos_plan" {
  description = "Create an ddos plan - Default is false"
  type        = bool
  default     = false
}

# DDoS Protection
variable "enable_ddos" {
  description = "Enable Azure DDoS Protection Standard and attach to VNet."
  type        = bool
  default     = false
}

variable "ddos_plan_name" {
  description = "Name of the DDoS Protection Plan."
  type        = string
  default     = "tofu-ddos-plan"
}

