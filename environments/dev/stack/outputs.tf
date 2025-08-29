# Resource Group Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.resource_group.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = module.resource_group.id
}

# Azure Data Lake Storage Outputs
output "adls_account_name" {
  description = "Name of the Azure Data Lake Storage account"
  value       = module.adls.account_name
}

output "adls_account_id" {
  description = "ID of the Azure Data Lake Storage account"
  value       = module.adls.account_id
}

output "adls_containers" {
  description = "Map of container names and their properties"
  value       = module.adls.containers
}

# Azure Data Factory Outputs
output "adf_name" {
  description = "Name of the Azure Data Factory"
  value       = module.adf.name
}

output "adf_id" {
  description = "ID of the Azure Data Factory"
  value       = module.adf.id
}

# Google Cloud Storage Outputs
output "gcs_buckets" {
  description = "Map of GCS bucket names and their properties"
  value       = module.gcs.buckets
}

# Google Cloud Service Account Outputs
output "gcp_service_account_email" {
  description = "Email of the GCP service account"
  value       = module.gcp_service_account.email
  sensitive   = true
}

# Key Vault Outputs
output "key_vault_name" {
  description = "Name of the Azure Key Vault"
  value       = module.key_vault.name
}

output "key_vault_id" {
  description = "ID of the Azure Key Vault"
  value       = module.key_vault.id
}

# Pipeline Configuration Summary
output "pipeline_summary" {
  description = "Summary of the data pipeline infrastructure"
  value = {
    project_name    = var.project_name
    environment     = var.environment
    azure_location  = var.azure_location
    gcp_project_id  = var.gcp_project_id
    gcp_region      = var.gcp_region
    data_flow = {
      source         = "Google Analytics"
      intermediate   = "Google Cloud Storage"
      destination    = "Azure Data Lake Storage"
      orchestration  = "Azure Data Factory"
    }
  }
}
