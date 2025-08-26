variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location of the Key Vault"
  type        = string
  default     = "EAST US"
}

variable "sku_name" {
  description = "SKU that is to be selected."
  type        = string
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted items."
  type        = number
  default     = 90
}

variable "enabled_for_disk_encryption" {
  description = "Whether the resource is enabled for disk encryption."
  type        = bool
  default     = true
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled."
  type        = bool
  default     = false
}

variable "enable_rbac_authorization" {
  description = "Whether Role-Based Access Control (RBAC) is enabled for the resource."
  type        = bool
  default     = false
}

variable "enabled_for_deployment" {
  description = "Whether the resource is enabled for deployment."
  type        = bool
  default     = true
}

variable "enabled_for_template_deployment" {
  description = "Whether the resource is enabled for template deployments."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the resource."
  type        = bool
  default     = true
}

variable "access_policies" {
  description = "Access policies for the key vault."
  type = map(object({
    object_id               = string
    application_id          = optional(string)
    certificate_permissions = optional(list(string), [])
    key_permissions         = optional(list(string), [])
    secret_permissions      = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  default = null
}

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
  default     = ""
}

variable "short_name" {
  description = "Provide application/resource short name for the resource"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Map of tags."
  type        = map(string)
}








