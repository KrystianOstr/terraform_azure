variable "rg_name" {
  type        = string
  description = "Name of the RG"
  default     = "my_main_rg"
}

variable "rg_location" {
  type        = string
  description = "Name of the Location for resources"
  default     = "East US"
}

variable "user_vm" {
  type        = string
  description = "Name of the user for vms"
  default     = "azureuser"
  sensitive   = true
}

variable "environment" {
  type        = string
  description = "Define an environment for resource"
  default     = "dev"
}

variable "owner" {
  type        = string
  description = "Owner's name"
  default     = "DevOps Team"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "DemoInfra"
}

variable "networking-tag" {
  type        = string
  description = "Tag for networking resources"
  default     = "network"
}

variable "compute-tag" {
  type        = string
  description = "Tag for compute resources"
  default     = "compute"
}
