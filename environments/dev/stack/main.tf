terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Azure Provider Configuration
provider "azurerm" {
  features {}
}

# Google Cloud Provider Configuration
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Local variables for common configuration
locals {
  common_tags = var.common_tags
  
  # Naming convention following HashiCorp best practices
  naming_convention = {
    prefix = var.resource_group_name
  }
}

# Resource Group
module "resource_group" {
  source = "../../../modules/resource-group"
  
  resource_group_name = var.resource_group_name
  location           = var.azure_location
  tags               = local.common_tags
}

# Azure Data Lake Storage Gen2
module "storage" {
  source = "../../../modules/storage"
  
  storage_account_name = var.storage_account_name
  resource_group_name  = module.resource_group.resource_group_name
  location            = var.azure_location
  account_tier        = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags                = local.common_tags
}

# Azure Data Factory
module "data_factory" {
  source = "../../../modules/data-factory"
  
  data_factory_name   = var.data_factory_name
  resource_group_name = module.resource_group.resource_group_name
  location           = var.azure_location
  tags               = local.common_tags
  tenant_id          = var.azure_tenant_id
  storage_endpoint   = module.storage.storage_account_primary_dfs_endpoint
}

# Azure Key Vault for storing secrets
module "key_vault" {
  source = "../../../modules/key-vault"
  
  key_vault_name     = var.key_vault_name
  resource_group_name = module.resource_group.resource_group_name
  location           = var.azure_location
  tags               = local.common_tags
  tenant_id          = var.azure_tenant_id
  object_id          = module.data_factory.data_factory_identity.principal_id
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  purge_protection_enabled   = var.key_vault_purge_protection_enabled
  sku_name                   = var.key_vault_sku_name
}

# GCP Service Account for Azure Data Factory
module "gcp_service_account" {
  source = "../../../modules/gcp-service-account"
  
  gcp_project_id = var.gcp_project_id
  azure_tenant_id = var.azure_tenant_id
  
  service_account_id = "adf-ga4-integration"
  service_account_display_name = "Azure Data Factory GA4 Integration"
  service_account_description = "Service account for Azure Data Factory to access GA4 and BigQuery data"
  
  enable_bigquery_access = true
  enable_analytics_access = true
  create_service_account_key = true
  enable_workload_identity = true  # Enable for more secure authentication
}

# BigQuery Dataset for GA4 Data
module "bigquery_ga4" {
  source = "../../../modules/bigquery-ga4"
  
  gcp_project_id = var.gcp_project_id
  gcp_region = var.gcp_region
  
  ga4_dataset_id = var.ga4_dataset_id
  ga4_dataset_friendly_name = "GA4 Analytics Data"
  ga4_dataset_description = "Dataset containing Google Analytics 4 data for analytics and reporting"
  
  create_ga4_events_table = true
  create_ga4_users_table = true
  create_ga4_sessions_table = true
  
  enable_adf_access = true
  adf_service_account_email = module.gcp_service_account.service_account_email
  
  depends_on = [module.gcp_service_account]
}

# BigQuery Linked Service for Azure Data Factory
module "bigquery_connection" {
  source = "../../../modules/bigquery-connection"
  
  data_factory_id = module.data_factory.data_factory_id
  gcp_project_id = var.gcp_project_id
  gcp_service_account_email = module.gcp_service_account.service_account_email
  gcp_client_id = var.gcp_client_id
  gcp_private_key = var.gcp_private_key
  gcp_tenant_id = var.azure_tenant_id
  
  use_oauth2_authentication = false
  
  depends_on = [module.data_factory, module.gcp_service_account]
}

# Store GCP credentials in Azure Key Vault for security
resource "azurerm_key_vault_secret" "gcp_service_account_key" {
  name         = "gcp-service-account-key"
  value        = var.gcp_private_key
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.key_vault]
}

resource "azurerm_key_vault_secret" "gcp_client_id" {
  name         = "gcp-client-id"
  value        = var.gcp_client_id
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.key_vault]
}

resource "azurerm_key_vault_secret" "gcp_private_key_id" {
  name         = "gcp-private-key-id"
  value        = var.gcp_private_key_id
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.key_vault]
}
