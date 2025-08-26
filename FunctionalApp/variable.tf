variable "naming_convention_properties" {
  description = "Properties for naming convention"
  type = object({
    subscription_name = string
    environment       = string
    # version           = optional(string, "01")
  })
}

variable "version_func" {
  description = "Version of the fucntion app"
  type        = string
}

variable "project_code" {
  description = "Provide application/resource project code for the resource."
  type        = string
  default     = ""
}

variable "short_name" {
  description = "Provide application/resource short name for the resource."
  type        = string
  default     = ""
}

variable "location" {
  description = "Location of the resource"
  type =string
  default = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group where function app will reside"
  type = string
  default = ""
}

variable "kind" {
  description = "Kind of Function App eg Linux or Windows"
  type = string
  default = "Linux"
}

variable "os_type" {
  description = "Kind of Function App eg Linux or Windows"
  type = string
  default = "linux"
}

variable "storage_account_name" {
  description = "Name of the Storage account"
  type = string
}

variable "Function_worker_runtime" {
  description = "Worker Runtime for Function app"
  type = string
}

variable "linux_fx_version"{
  description = "Linux Version for the env"
  type = string
}

variable "identity_type" {
  description = "Identity for the FUNTIONAPP"
  type = string
  default = "SystemAssigned"
}

variable "tags" {
  description = "Map of tags."
  type        = map(string)
}