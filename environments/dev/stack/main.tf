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
  common_tags = {
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Environment = var.environment
    Purpose     = "DataPipeline"
  }
  
  # Naming convention following HashiCorp best practices
  naming_convention = {
    prefix = "${var.project_name}-${var.environment}"
  }
}

# Resource Group
module "resource_group" {
  source = "../../../modules/resource-group"
  
  name     = "${local.naming_convention.prefix}-rg"
  location = var.azure_location
  tags     = local.common_tags
}

# Azure Data Lake Storage Gen2
module "adls" {
  source = "../../../modules/adls"
  
  name                = "${var.project_name}${var.environment}adls"
  resource_group_name = module.resource_group.name
  location           = var.azure_location
  account_tier       = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled     = true
  tags               = local.common_tags
  
  containers = {
    raw = {
      name         = "raw"
      access_type  = "private"
    }
    processed = {
      name         = "processed"
      access_type  = "private"
    }
    curated = {
      name         = "curated"
      access_type  = "private"
    }
  }
}

# Azure Data Factory
module "adf" {
  source = "../../../modules/adf"
  
  name                = "${local.naming_convention.prefix}-adf"
  resource_group_name = module.resource_group.name
  location           = var.azure_location
  tags               = local.common_tags
  
  # GitHub integration for CI/CD
  github_configuration = {
    repository_name = var.github_repository_name
    root_folder     = "/"
    branch_name     = "main"
    account_name    = var.github_account_name
  }
}

# Google Cloud Storage for intermediate data
module "gcs" {
  source = "../../../modules/gcs"
  
  project_id = var.gcp_project_id
  location   = var.gcp_region
  
  buckets = {
    ga-raw-data = {
      name          = "${var.project_name}-${var.environment}-ga-raw-data"
      location      = var.gcp_region
      force_destroy = true
    }
    ga-processed-data = {
      name          = "${var.project_name}-${var.environment}-ga-processed-data"
      location      = var.gcp_region
      force_destroy = true
    }
  }
}

# Google Cloud Service Account for ADF integration
module "gcp_service_account" {
  source = "../../../modules/gcp-service-account"
  
  project_id = var.gcp_project_id
  account_id = "${var.project_name}-${var.environment}-adf-sa"
  display_name = "Service Account for Azure Data Factory"
  
  # Grant access to GCS buckets
  bucket_permissions = [
    "storage.objects.get",
    "storage.objects.list",
    "storage.objects.create",
    "storage.objects.delete"
  ]
  
  buckets = [
    module.gcs.bucket_names["ga-raw-data"],
    module.gcs.bucket_names["ga-processed-data"]
  ]
}

# Azure Key Vault for storing secrets
module "key_vault" {
  source = "../../../modules/key-vault"
  
  name                = "${local.naming_convention.prefix}-kv"
  resource_group_name = module.resource_group.name
  location           = var.azure_location
  tags               = local.common_tags
  
  # Store GCP service account key separately
  gcp_service_account_key = module.gcp_service_account.private_key
}
