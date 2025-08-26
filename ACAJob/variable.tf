variable "naming_convention_properties" {
  description = "Properties for naming convention"
  type = object({
    subscription_name = string
    environment       = string
    version           = optional(string, "01")
  })
}

variable "project_code" {
  description = "Provide application/resource project code for the resource"
  type        = string
  default     = "" # Default is an empty string, so it's optional
}


variable "short_name" {
  description = "Provide application/resource short name for the resource"
  type        = string
  default     = "" # Default is an empty string, so it's optional
}

variable "location" {
  description = "Azure location for the VM."
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Azure resource group name for the ACA."
  type        = string
}

variable "log_analytics_sku" {
  description = "Azure log analytics sku for the ACA."
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Azure Retention days for logs."
  type        = string
  default     = "30"
}

variable "cron_expression" {
  description = "Azure resource group name for the ACA."
  type        = string
}
variable "secrets" {
  type = map(object({
    aca_secret_name = string
    secret_id       = optional(string,null)
    secret_value    = optional(string)
  }))
  description = "Map of secrets with name and Key Vault secret ID"
}

variable "registry_server" {
  description = "ACR URL for the ACA."
  type        = string
}
variable "container" {
  description = "Map of container job configurations"
  type = map(object({
    name   = optional(string, "")
    image  = string
    cpu    = number
    memory = string
    env_vars = optional(list(object({
      name        = string
      value       = optional(string)
      secret_name = optional(string)
    })), null)
  }))
}

variable "tags" {
  description = "Map of tags."
  type        = map(string)
  default     = null
}
