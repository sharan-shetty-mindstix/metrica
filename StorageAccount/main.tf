# Locals
locals {
  type_of_resource = var.storage_account_account_kind == "FileStorage" ? "share" : "st"

  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}${var.project_code}${local.type_of_resource}${var.short_name}${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}${var.project_code}${local.type_of_resource}${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/storage_account
resource "azurerm_storage_account" "storage_account" {
  name                             = local.final_resource_name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  account_kind                     = var.storage_account_account_kind
  account_tier                     = var.storage_account_account_tier
  account_replication_type         = var.storage_account_account_replication_type
  cross_tenant_replication_enabled = var.storage_account_cross_tenant_replication_enabled
  access_tier                      = var.storage_account_access_tier
  edge_zone                        = var.storage_account_edge_zone
  min_tls_version                  = var.storage_account_min_tls_version
  allow_nested_items_to_be_public  = var.storage_account_allow_nested_items_to_be_public
  shared_access_key_enabled        = var.storage_account_shared_access_key_enable
  public_network_access_enabled    = var.storage_account_public_network_access_enabled
  default_to_oauth_authentication  = var.storage_account_default_to_oauth_authentication
  is_hns_enabled                   = var.storage_account_is_hns_enabled
  nfsv3_enabled                    = var.storage_account_nfsv3_enabled
  https_traffic_only_enabled       = var.https_traffic_only_enabled

  dynamic "custom_domain" {
    for_each = var.storage_account_custom_domain != null ? [1] : []
    content {
      name          = var.storage_account_custom_domain.name
      use_subdomain = var.storage_account_custom_domain.use_subdomain
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.storage_account_customer_managed_key != null ? [1] : []
    content {
      key_vault_key_id          = var.storage_account_customer_managed_key.key_vault_key_id
      user_assigned_identity_id = var.storage_account_customer_managed_key.user_assigned_identity_id
    }
  }

  dynamic "identity" {
    for_each = var.storage_account_identity != null ? [1] : []
    content {
      type         = var.storage_account_identity.type
      identity_ids = var.storage_account_identity.identity_ids
    }
  }

  dynamic "blob_properties" {
    for_each = var.storage_account_blob_properties != null ? [1] : []
    content {
      dynamic "cors_rule" {
        for_each = var.storage_account_blob_properties.cors_rule != null ? [1] : []
        content {
          allowed_headers    = var.storage_account_blob_properties.cors_rule.allowed_headers
          allowed_methods    = var.storage_account_blob_properties.cors_rule.allowed_methods
          allowed_origins    = var.storage_account_blob_properties.cors_rule.allowed_origins
          exposed_headers    = var.storage_account_blob_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.storage_account_blob_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = var.storage_account_blob_properties.delete_retention_policy != null ? [1] : []
        content {
          days = var.storage_account_blob_properties.delete_retention_policy.days
        }
      }

      dynamic "restore_policy" {
        for_each = var.storage_account_blob_properties.restore_policy != null ? [1] : []
        content {
          days = var.storage_account_blob_properties.restore_policy.days
        }
      }

      versioning_enabled            = var.storage_account_blob_properties.versioning_enabled
      change_feed_enabled           = var.storage_account_blob_properties.change_feed_enabled
      change_feed_retention_in_days = var.storage_account_blob_properties.change_feed_retention_in_days
      default_service_version       = var.storage_account_blob_properties.default_service_version
      last_access_time_enabled      = var.storage_account_blob_properties.last_access_time_enabled

      dynamic "container_delete_retention_policy" {
        for_each = var.storage_account_blob_properties.container_delete_retention_policy != null ? [1] : []
        content {
          days = var.storage_account_blob_properties.container_delete_retention_policy.days
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = var.storage_account_queue_properties != null ? [1] : []
    content {
      dynamic "cors_rule" {
        for_each = var.storage_account_queue_properties.cors_rule != null ? [1] : []
        content {
          allowed_headers    = var.storage_account_queue_properties.cors_rule.allowed_headers
          allowed_methods    = var.storage_account_queue_properties.cors_rule.allowed_methods
          allowed_origins    = var.storage_account_queue_properties.cors_rule.allowed_origins
          exposed_headers    = var.storage_account_queue_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.storage_account_queue_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = var.storage_account_queue_properties.logging != null ? [1] : []
        content {
          delete                = var.storage_account_queue_properties.logging.delete
          read                  = var.storage_account_queue_properties.logging.read
          version               = var.storage_account_queue_properties.logging.version
          write                 = var.storage_account_queue_properties.logging.write
          retention_policy_days = var.storage_account_queue_properties.logging.retention_policy_days
        }
      }

      dynamic "minute_metrics" {
        for_each = var.storage_account_queue_properties.minute_metrics != null ? [1] : []
        content {
          enabled               = var.storage_account_queue_properties.minute_metrics.enabled
          version               = var.storage_account_queue_properties.minute_metrics.version
          include_apis          = var.storage_account_queue_properties.minute_metrics.include_apis
          retention_policy_days = var.storage_account_queue_properties.minute_metrics.retention_policy_days
        }
      }

      dynamic "hour_metrics" {
        for_each = var.storage_account_queue_properties.hour_metrics != null ? [1] : []
        content {
          enabled               = var.storage_account_queue_properties.hour_metrics.enabled
          version               = var.storage_account_queue_properties.hour_metrics.version
          include_apis          = var.storage_account_queue_properties.hour_metrics.include_apis
          retention_policy_days = var.storage_account_queue_properties.hour_metrics.retention_policy_days
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = var.storage_account_static_website != null ? [1] : []
    content {
      index_document     = var.storage_account_static_website.index_document
      error_404_document = var.storage_account_static_website.error_404_document
    }
  }

  dynamic "share_properties" {
    for_each = var.storage_account_share_properties != null ? [1] : []
    content {
      dynamic "cors_rule" {
        for_each = var.storage_account_share_properties.cors_rule != null ? [1] : []
        content {
          allowed_headers    = var.storage_account_share_properties.cors_rule.allowed_headers
          allowed_methods    = var.storage_account_share_properties.cors_rule.allowed_methods
          allowed_origins    = var.storage_account_share_properties.cors_rule.allowed_origins
          exposed_headers    = var.storage_account_share_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.storage_account_share_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = var.storage_account_share_properties.retention_policy != null ? [1] : []
        content {
          days = var.storage_account_share_properties.retention_policy.days
        }
      }

      dynamic "smb" {
        for_each = var.storage_account_share_properties.smb != null ? [1] : []
        content {
          versions                        = var.storage_account_share_properties.smb.versions
          authentication_types            = var.storage_account_share_properties.smb.authentication_types
          kerberos_ticket_encryption_type = var.storage_account_share_properties.smb.kerberos_ticket_encryption_type
          channel_encryption_type         = var.storage_account_share_properties.smb.channel_encryption_type
          multichannel_enabled            = var.storage_account_share_properties.smb.multichannel_enabled
        }
      }
    }
  }

  dynamic "network_rules" {
    for_each = var.storage_account_network_rules != null ? [1] : []
    content {
      default_action             = var.storage_account_network_rules.default_action
      bypass                     = var.storage_account_network_rules.bypass
      ip_rules                   = var.storage_account_network_rules.ip_rules
      virtual_network_subnet_ids = var.storage_account_network_rules.virtual_network_subnet_ids
      dynamic "private_link_access" {
        for_each = var.storage_account_network_rules.private_link_access != null ? [1] : []
        content {
          endpoint_resource_id = var.storage_account_network_rules.private_link_access.endpoint_resource_id
          endpoint_tenant_id   = var.storage_account_network_rules.private_link_access.endpoint_tenant_id
        }
      }
    }
  }

  large_file_share_enabled = var.storage_account_large_file_share_enabled

  dynamic "azure_files_authentication" {
    for_each = var.storage_account_azure_files_authentication != null ? [1] : []
    content {
      directory_type = var.storage_account_azure_files_authentication.directory_type
      dynamic "active_directory" {
        for_each = var.storage_account_azure_files_authentication.active_directory != null ? [1] : []
        content {
          domain_name         = var.storage_account_azure_files_authentication.active_directory.domain_name
          domain_guid         = var.storage_account_azure_files_authentication.active_directory.domain_guid
          domain_sid          = var.storage_account_azure_files_authentication.active_directory.domain_sid
          storage_sid         = var.storage_account_azure_files_authentication.active_directory.storage_sid
          forest_name         = var.storage_account_azure_files_authentication.active_directory.forest_name
          netbios_domain_name = var.storage_account_azure_files_authentication.active_directory.netbios_domain_name
        }
      }
    }
  }

  dynamic "routing" {
    for_each = var.storage_account_routing != null ? [1] : []
    content {
      publish_internet_endpoints  = var.storage_account_routing.publish_internet_endpoints
      publish_microsoft_endpoints = var.storage_account_routing.publish_microsoft_endpoints
      choice                      = var.storage_account_routing.choice
    }
  }

  queue_encryption_key_type         = var.storage_account_queue_encrption_key_type
  table_encryption_key_type         = var.storage_account_table_encrption_key_type
  infrastructure_encryption_enabled = var.storage_account_infrastructure_encryption_enabled

  dynamic "immutability_policy" {
    for_each = var.storage_account_immutability_policy != null ? [1] : []
    content {
      allow_protected_append_writes = var.storage_account_immutability_policy.allow_protected_append_writes
      state                         = var.storage_account_immutability_policy.state
      period_since_creation_in_days = var.storage_account_immutability_policy.period_since_creation_in_days
    }
  }

  dynamic "sas_policy" {
    for_each = var.storage_account_sas_policy != null ? [1] : []
    content {
      expiration_action = var.storage_account_sas_policy.expiration_action
      expiration_period = var.storage_account_sas_policy.expiration_period
    }
  }

  allowed_copy_scope = var.storage_account_allowed_copy_scope
  sftp_enabled       = var.storage_account_sftp_enable
  tags               = var.storage_account_tags
}

# Storage Account container
# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/storage_container
resource "azurerm_storage_container" "storage" {
  for_each              = var.containers
  name                  = each.value.name
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = each.value.access_type
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/storage_share
resource "azurerm_storage_share" "storage_share" {
  for_each           = var.shares
  name               = each.value.name
  storage_account_id = azurerm_storage_account.storage_account.id
  quota              = each.value.quota
  enabled_protocol   = each.value.enabled_protocol

  dynamic "acl" {
    for_each = each.value.acl
    content {
      id = acl.value.id

      access_policy {
        permissions = acl.value.access_policy.permissions
        start       = acl.value.access_policy.start
        expiry      = acl.value.access_policy.expiry
      }
    }
  }
}