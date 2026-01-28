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

variable "storage_account_host_name" {
  type = string
}

variable "app_gateway_public_ip" {
  type        = string
  description = "FQDN of Application Gateway public IP"
}

variable "static_storage_account_id" {
  type = string
}