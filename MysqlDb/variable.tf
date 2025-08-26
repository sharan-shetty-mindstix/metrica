variable "resource_group_name" {
  description = "The name of the resource group where the MySQL server will be created"
  type        = string
}

variable "location" {
  description = "Azure region where the resource group and server will be created"
  type        = string
}


variable "server_name" {
  description = "The name of the MySQL flexible server"
  type        = string
}

variable "mysql_version" {
  description = "The version of MySQL to use"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the MySQL server"
  type        = string
}

variable "sku_name" {
  description = "The SKU name for the MySQL server"
  type        = string
}

variable "storage" {
  description = "Object of storage configuration."
  type = object({
    auto_grow_enabled  = optional(bool, true)
    size_gb            = optional(number)
    io_scaling_enabled = optional(bool, false)
    iops               = optional(number)
  })
  default = {}
}

variable "backup_retention_days" {
  description = "The days to retain backups for. Must be between 1 and 35."
  type        = number
  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 35
    error_message = "The backup_retention_days must be null or if specified between 7 and 35."
  }
  default = 7
}

variable "geo_redundant_backup" {
  description = "Turn Geo-redundant server backups on/off. This allows you to choose between locally redundant or geo-redundant backup storage in the General Purpose and Memory Optimized tiers. When the backups are stored in geo-redundant backup storage, they are not only stored within the region in which your server is hosted, but are also replicated to a paired data center. This provides better protection and ability to restore your server in a different region in the event of a disaster"
  type        = bool
  default     = false
}

variable "high_availability" {
  description = <<EOT
Object of high availability configuration. Set null to disable high availability. 
If not null, it must include the mode and optionally the standby availability zone.
EOT
  type = object({
    mode                      = optional(string, "SameZone")
    standby_availability_zone = optional(number)
  })

  default = null
}

variable "tags" {
  description = "Tags to apply to the MySQL server resources"
  type        = map(string)
  default     = {}
}

variable "short_name" {
  type        = string
  description = "Short name for the resource"
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
  type        = string
  description = "Project code used in resource naming"
}

variable "db_zone" {
  type        = string
  description = "The availability zone for the database"
  default     = 1
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet for the MySQL flexible server"
  default = ""
}

variable "generated_secrets_key_vault_secret_config" {
  description = "Configuration for the private DNS zone and its virtual network link"
  type = object({
    name                           = string
    key_vault_resource_id          = string
    expiration_date_length_in_days = number
  })
}

variable "private_dns_zone_id" {
  description = "The ID of the Private DNS Zone to create the MySQL Flexible server."
  type        = string
  default     = null
}

variable "create_mode" {
  description = "The creation mode. Can be used to restore or replicate existing servers. Possible values are `Default`, `Replica`, `GeoRestore`, and `PointInTimeRestore`. Defaults to `Default`"
  default     = "Default"
}

variable "source_server_id" {
  description = "For creation modes other than `Default`, the source server ID to use."
  default     = null
}

variable "primary_mysql_db_name" {
  description = "The name of the primary MySQL database that replicas depend on"
  type        = string
  default     = ""
}

variable "primary_mysql_db_rg" {
  description = "The name of the primary MySQL database that replicas depend on"
  type        = string
  default     = ""
}

variable "ssvc_resource_group_name" {
  description = "Name of the existing resource group where the VNet will be created."
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet."
  type        = string
}

variable "vnet_name" {
  description = "Name of the Vnet."
  type        = string
}





