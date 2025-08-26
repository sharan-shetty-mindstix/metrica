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
  default     = "US East"
}

variable "key_vault_name" {
  description = "Name of the key vault for the linked service"
  type        = string
  default =  ""
}

variable "resource_group_name" {
  description = "Name of the resource group where the VM will be created."
  type        = string
}

variable "public_network_enabled" {
  description = "Whether public network access is enabled for the resource."
  type        = bool
  default     = false
}

variable "identity" {
  description = "Type of identity will be created."
  type        = string
  default     = "system_assigned"
}

variable "tags" {
  description = "Map of tags."
  type        = map(string)
  default     = null
}

variable "managed_virtual_network_enabled" {
  description = "Managed Virtual Network needs to be enabled"
  type        = bool
  default     = false
}

variable "github_configurations" {
  description = "Github configguration needs to be enabled for data factory"
  type = object({
    repository_name = optional(string)
    root_folder     = optional(string)
    branch_name     = optional(string)
    account_name    = optional(string)
  })
  default = null
}

variable "data_factory_self_hosted_integration_config" {
  description = "This is Self Hosted Integration Runtime"
  type = map(object({
    name            = string
    description     = optional(string, "")
    rbac_authorization = optional(object({
      resource_id = list(string)
    }))
  }))
}

variable "key_vault_linked_service_description" {
  description = "Description for Azure key vault linked service"
  type        = string
  default     = ""
}
