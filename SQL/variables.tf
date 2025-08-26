variable "naming_convention_properties" {
  description = "Properties for naming convention"
  type = object({
    subscription_name = string
    environment       = string
    version           = optional(string, "01") # Default version is "01"
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

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Name of region"
  type        = string
}

variable "sql_version" {
  description = "Name of region"
  type        = string
  default     = "12.0"
}

variable "administrator_login" {
  description = "login username for the sql server"
  type        = string
}

variable "administrator_login_password" {
  description = "Login password for sql"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Public access for the sql server"
  type        = bool
}

variable "tags" {
  description = "Tags to apply to the MySQL server resources"
  type        = map(string)
  default     = {}
}

variable "identity" {
  description = "Identity for the service"
  type        = string
  default     = "SystemAssigned"
}

variable "minimum_tls_version" {
  description = "Minimum TLS version for the service"
  type        = string
  default     = "1.2"
}

variable "outbound_network_restriction_enabled" {
  description = "Enable restrcition on outbound enabled"
  type        = bool
  default     = false
}

variable "elastic_pool_configs" {
  description = "Map of elastic pool configurations"
  type = map(object({
    elastic_pool_name     = string
    elastic_pool_sku      = string
    elastic_pool_tier     = string
    elastic_pool_capacity = number
    elastic_pool_family = string
    min_capacity          = number
    max_capacity          = number
    elastic_max_size_gb   = number
  }))
  default = {}
}

variable "sql_databases" {
  description = "Map of Azure SQL databases to create"
  type = map(object({
    database_name     = string
    collation         = string
    database_sku_name = string
    elastic_pool_name = string # Must match a key in azurerm_mssql_elasticpool
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
  }))
  default = {}
}
