variable "rg_name" {
  type = string
  default = "tofurg"
  
}
variable "storage_account_name" {
  type = string
  default = "tofustaticstorage632"
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

variable "your_ip_address" {
  type = string
}


variable "private_endpoint_subnet_id" {
  type = string
}

variable "vnet_ide" {
  type = string
}
