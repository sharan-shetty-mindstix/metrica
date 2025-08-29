variable "key_vault_name" {
  description = "Name of the key vault"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "object_id" {
  description = "Object ID for access policy"
  type        = string
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention days"
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Enable purge protection"
  type        = bool
  default     = false
}

variable "sku_name" {
  description = "SKU name for key vault"
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "key_permissions" {
  description = "Key permissions for access policy"
  type        = list(string)
  default = [
    "Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore", "Recover"
  ]
}

variable "secret_permissions" {
  description = "Secret permissions for access policy"
  type        = list(string)
  default = [
    "Get", "List", "Set", "Delete", "Backup", "Restore", "Recover"
  ]
}

variable "certificate_permissions" {
  description = "Certificate permissions for access policy"
  type        = list(string)
  default = [
    "Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore", "Recover"
  ]
}
