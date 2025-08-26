# List of variables are used in Storage Account Module:
# environment (Required)
# location (Required)
# projectCode (Required)
# resource_group_name (Required)
# saMetadata (Required)
# storage_account_account_replication_type (Required)
# storage_account_account_tier (Required)
# subscriptionName (Required)
# containers (Optional)
# resource_name (Optional)
# short_name (Optional)
# storage_account_access_tier (Optional)
# storage_account_allowed_copy_scope (Optional)
# storage_account_azure_files_authentication (Optional)
# storage_account_blob_properties (Optional)
# storage_account_cross_tenant_replication_enabled (Optional)
# storage_account_custom_domain (Optional)
# storage_account_customer_managed_key (Optional)
# storage_account_default_to_oauth_authentication (Optional)
# storage_account_edge_zone (Optional)
# storage_account_enable_http_traffic_only (Optional)
# storage_account_identity (Optional)
# storage_account_immutability_policy (Optional)
# storage_account_infrastructure_encryption_enabled (Optional)
# storage_account_is_hns_enabled (Optional)
# storage_account_large_file_share_enabled (Optional)
# storage_account_min_tls_version (Optional)
# storage_account_network_rules (Optional)
# storage_account_nfsv3_enabled (Optional)
# storage_account_public_network_access_enabled (Optional)
# storage_account_queue_encryption_key_type (Optional)
# storage_account_queue_properties (Optional)
# storage_account_routing (Optional)
# storage_account_sas_policy (Optional)
# storage_account_shared_access_key_enable (Optional)
# storage_account_sftp_enable (Optional)
# storage_account_share_properties (Optional)
# storage_account_static_website (Optional)
# storage_account_table_encryption_key_type (Optional)
# storage_account_tags (Optional)


variable "resource_name" {
  type    = string
  default = ""
}

# To utilize the "naming_convention_properties" variable, provide values for its components following the specified naming convention.
# The invocation format is: <subscriptionName> <projectCode> <type_of_resource> <short_name> <environment>.
# For example, if the values for 
# subscriptionName = "lnos"
# projectCode      = "poc"
# type_of_resource = "stblob"
# short_name       = "demo"
# environment      = "sb"
# Then, the final_resource_name would be: lnospocstblobdemosb.
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

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  description = "The location for the resource."
  type        = string
}

variable "storage_account_account_kind" {
  description = "The kind of storage account to create. Possible values are Storage, StorageV2, BlobStorage."
  type        = string
  default     = null
}

variable "storage_account_account_tier" {
  description = "The storage account SKU. Possible values are Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_ZRS, Premium_LRS, Premium_ZRS, Standard_GZRS, Standard_RAGZRS, Premium_GRS, Premium_RAGRS, Premium_ZRS."
  type        = string
}

variable "storage_account_account_replication_type" {
  description = "The type of replication to use for the storage account. Possible values are LRS, GRS, RAGRS, ZRS."
  type        = string
}

variable "storage_account_cross_tenant_replication_enabled" {
  description = "Is Cross Tenant Replication is enabled? true or false."
  type        = bool
  default     = null
}

variable "storage_account_access_tier" {
  description = "The access tier for the storage account. Possible values are Hot or Cool."
  type        = string
  default     = null
}

variable "storage_account_edge_zone" {
  description = "The Edge Zone for the storage account."
  type        = string
  default     = null
}

variable "storage_account_min_tls_version" {
  description = "The minimum supported TLS version for the storage account. Possible values are 'TLS1_0', 'TLS1_1', 'TLS1_2', 'TLS1_2', 'TLS1_3'."
  type        = string
  default     = "TLS1_2"
}

variable "storage_account_allow_nested_items_to_be_public" {
  description = "Allows or disallows public access to nested blobs."
  type        = bool
  default     = true
}

variable "storage_account_shared_access_key_enable" {
  description = "Allows or disallows shared access key based authentication for the storage account."
  type        = bool
  default     = true
}

variable "storage_account_public_network_access_enabled" {
  description = "Allows or disallows public network access to the storage account."
  type        = bool
  default     = true
}

variable "storage_account_default_to_oauth_authentication" {
  description = "Specifies whether the default authentication method for the storage account should be OAuth."
  type        = bool
  default     = false
}

variable "storage_account_is_hns_enabled" {
  description = "Specifies whether Hierarchical Namespace is enabled for the storage account."
  type        = bool
  default     = false
}

variable "storage_account_nfsv3_enabled" {
  description = "Specifies whether NFS v3.0 is enabled for the storage account."
  type        = bool
  default     = false
}

variable "storage_account_custom_domain" {
  description = "Custom domain configuration for the storage account."
  type = object({
    name          = string
    use_subdomain = optional(bool)
  })
  default = null
}

variable "storage_account_customer_managed_key" {
  description = "Customer-managed key configuration for the storage account."
  type = object({
    key_vault_key_id          = string
    user_assigned_identity_id = string
  })
  default = null
}

variable "storage_account_identity" {
  description = "Identity configuration for the storage account."
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "storage_account_blob_properties" {
  description = "Blob properties configuration for the storage account."
  type = object({
    cors_rule = object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    })

    delete_retention_policy = object({
      days = optional(number)
    })

    restore_policy = object({
      days = number
    })

    versioning_enabled            = optional(bool, false)
    change_feed_enabled           = optional(bool, false)
    change_feed_retention_in_days = optional(number)
    default_service_version       = optional(string)
    last_access_time_enabled      = optional(bool)

    container_delete_retention_policy = object({
      days = optional(number)
    })
  })
  default = null
}

variable "storage_account_queue_properties" {
  description = "Queue properties configuration for the storage account."
  type = object({
    cors_rule = object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    })

    logging = object({
      delete                = bool
      read                  = bool
      version               = string
      write                 = bool
      retention_policy_days = optional(number)
    })

    minute_metrics = object({
      enabled               = bool
      version               = string
      include_apis          = optional(bool)
      retention_policy_days = optional(number)
    })

    hour_metrics = object({
      enabled               = bool
      version               = string
      include_apis          = optional(bool)
      retention_policy_days = optional(number)
    })
  })
  default = null
}

variable "storage_account_static_website" {
  description = "Static website configuration for the storage account."
  type = object({
    index_document     = optional(string)
    error_404_document = optional(string)
  })
  default = null
}

variable "storage_account_share_properties" {
  description = "Share properties configuration for the storage account."
  type = object({
    cors_rule = object({
      allowed_headers    = list(string)
      allowed_methods    = list(string)
      allowed_origins    = list(string)
      exposed_headers    = list(string)
      max_age_in_seconds = number
    })

    retention_policy = object({
      days = optional(number)
    })

    smb = object({
      versions                        = optional(list(string))
      authentication_types            = optional(list(string))
      kerberos_ticket_encryption_type = optional(list(string))
      channel_encryption_type         = optional(list(string))
      multichannel_enabled            = optional(bool)
    })
  })
  default = null
}

variable "storage_account_network_rules" {
  description = "Network rules configuration for the storage account."
  type = object({
    default_action             = string
    bypass                     = optional(list(string))
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
    private_link_access = optional(object({
      endpoint_resource_id = string
      endpoint_tenant_id   = optional(string)
    }))
  })
  default = null
}

variable "storage_account_large_file_share_enabled" {
  description = "Specifies whether Large File Shares are enabled for the storage account."
  type        = bool
  default     = null
}

variable "storage_account_azure_files_authentication" {
  description = "Azure Files authentication configuration for the storage account."
  type = object({
    directory_type = string
    active_directory = optional(object({
      domain_name         = string
      domain_guid         = string
      domain_sid          = optional(string)
      storage_sid         = optional(string)
      forest_name         = optional(string)
      netbios_domain_name = optional(string)
    }))
  })
  default = null
}

variable "storage_account_routing" {
  description = "Routing configuration for the storage account."
  type = object({
    publish_internet_endpoints  = optional(bool)
    publish_microsoft_endpoints = optional(bool)
    choice                      = optional(string)
  })
  default = null
}

variable "storage_account_queue_encrption_key_type" {
  description = "The encryption key type to use for the storage account queues. Possible values are Account and Service."
  type        = string
  default     = null
}

variable "storage_account_table_encrption_key_type" {
  description = "The encryption key type to use for the storage account tables. Possible values are Account and Service."
  type        = string
  default     = null
}

variable "storage_account_infrastructure_encryption_enabled" {
  description = "Specifies whether infrastructure encryption is enabled for the storage account."
  type        = bool
  default     = null
}

variable "storage_account_immutability_policy" {
  description = "Immutability policy configuration for the storage account."
  type = object({
    allow_protected_append_writes = bool
    state                         = string
    period_since_creation_in_days = number
  })
  default = null
}


variable "storage_account_sas_policy" {
  description = "Shared Access Signature (SAS) policy configuration for the storage account."
  type = object({
    expiration_action = optional(string)
    expiration_period = string
  })
  default = null
}

variable "storage_account_allowed_copy_scope" {
  description = "Specifies the allowed copy scope for the storage account."
  type        = string
  default     = null
}

variable "storage_account_sftp_enable" {
  description = "Specifies whether SFTP is enabled for the storage account."
  type        = bool
  default     = null
}

variable "https_traffic_only_enabled" {
  description = "Boolean flag which forces HTTPS if enabled"
  type        = bool
  default     = true
}

variable "storage_account_tags" {
  description = "A mapping of tags to assign to the storage account."
  type        = map(string)
  default     = null
}

# Storage Account Containers
variable "containers" {
  description = "Map of containers to create and their access levels."
  type = map(object({
    name        = string
    access_type = string
    metadata    = optional(map(string))
  }))
  default = {}
}

variable "shares" {
  description = "Map of storage shares to create, their quota, and access levels."
  type = map(object({
    name             = string
    quota            = number
    enabled_protocol = optional(string)
    acl = optional(list(object({
      id = string
      access_policy = object({
        permissions = string
        start       = string
        expiry      = string
      })
    })))
  }))
  default = {}
}


