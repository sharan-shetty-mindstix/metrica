# Azure Configuration
variable "azure_location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

# Resource Names
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "wgacamp-dapi-an-rg-stage01"
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  default     = "wgacanpdapianstblobstage01"
}

variable "key_vault_name" {
  description = "Name of the key vault"
  type        = string
  default     = "wgacamp-akv-stage01"
}

variable "data_factory_name" {
  description = "Name of the data factory"
  type        = string
  default     = "wgacamp-dapi-an-adf-stage01"
}

# Storage Configuration
variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

# Key Vault Configuration
variable "key_vault_soft_delete_retention_days" {
  description = "Soft delete retention days for key vault"
  type        = number
  default     = 7
}

variable "key_vault_purge_protection_enabled" {
  description = "Enable purge protection for key vault"
  type        = bool
  default     = true
}

variable "key_vault_sku_name" {
  description = "SKU name for key vault"
  type        = string
  default     = "standard"
}

# GCP Configuration
variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "gcp_credentials_file" {
  description = "Path to GCP service account key file"
  type        = string
  default     = "~/.gcp/credentials.json"
}

variable "gcp_service_account_email" {
  description = "GCP service account email"
  type        = string
}

variable "gcp_private_key_id" {
  description = "GCP private key ID"
  type        = string
}

variable "gcp_private_key" {
  description = "GCP private key"
  type        = string
  sensitive   = true
}

variable "gcp_client_id" {
  description = "GCP client ID"
  type        = string
}

# BigQuery Configuration
variable "bigquery_dataset" {
  description = "BigQuery dataset name"
  type        = string
  default     = "wgaca_data"
}

variable "bigquery_table" {
  description = "BigQuery table name"
  type        = string
  default     = "sales_data"
}

# Tags
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "STAGE"
    Project     = "wgaca"
    Purpose     = "Data Processing and Analytics"
    ManagedBy   = "Terraform"
    Compliance  = "SOC2"
  }
}
