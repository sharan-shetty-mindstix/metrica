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
  gcp_project_id     = var.gcp_project_id
  bigquery_dataset   = var.bigquery_dataset
  bigquery_table     = var.bigquery_table
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

# BigQuery Connection for Data Factory
module "bigquery_connection" {
  source = "../../../modules/bigquery-connection"
  
  data_factory_id        = module.data_factory.data_factory_id
  gcp_project_id         = var.gcp_project_id
  gcp_service_account_email = var.gcp_service_account_email
  gcp_private_key        = var.gcp_private_key
  gcp_client_id          = var.gcp_client_id
  service_principal_id   = module.data_factory.data_factory_identity.principal_id
  service_principal_key  = module.data_factory.data_factory_identity.principal_id
  tenant_id              = var.azure_tenant_id
  bigquery_dataset       = var.bigquery_dataset
}
