terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.80.0"
    }
  }
}

# Configure Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Configure Google Provider
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Get current Azure client configuration
data "azurerm_client_config" "current" {}

# Resource Group Module
module "resource_group" {
  source = "../../../modules/resource-group"
  
  resource_group_name = var.resource_group_name
  location           = var.azure_location
  tags               = var.common_tags
}

# Storage Module (ADLS2)
module "storage" {
  source = "../../../modules/storage"
  
  storage_account_name      = var.storage_account_name
  resource_group_name       = module.resource_group.resource_group_name
  location                  = module.resource_group.resource_group_location
  account_tier              = var.storage_account_tier
  account_replication_type  = var.storage_account_replication_type
  tags                      = var.common_tags
}

# Key Vault Module (AKV)
module "key_vault" {
  source = "../../../modules/key-vault"
  
  key_vault_name            = var.key_vault_name
  location                  = module.resource_group.resource_group_location
  resource_group_name       = module.resource_group.resource_group_name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  object_id                 = data.azurerm_client_config.current.object_id
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  purge_protection_enabled  = var.key_vault_purge_protection_enabled
  sku_name                  = var.key_vault_sku_name
  tags                      = var.common_tags
}

# Data Factory Module (ADF)
module "data_factory" {
  source = "../../../modules/data-factory"
  
  data_factory_name     = var.data_factory_name
  location             = module.resource_group.resource_group_location
  resource_group_name  = module.resource_group.resource_group_name
  storage_endpoint     = module.storage.storage_account_primary_dfs_endpoint
  tenant_id            = data.azurerm_client_config.current.tenant_id
  gcp_project_id       = var.gcp_project_id
  bigquery_dataset     = var.bigquery_dataset
  bigquery_table       = var.bigquery_table
  tags                 = var.common_tags
}

# BigQuery Connection Module
module "bigquery_connection" {
  source = "../../../modules/bigquery-connection"
  
  data_factory_id = module.data_factory.data_factory_id
  gcp_project_id = var.gcp_project_id
  gcp_service_account_email = var.gcp_service_account_email
  gcp_private_key = var.gcp_private_key
  gcp_client_id = var.gcp_client_id
}
