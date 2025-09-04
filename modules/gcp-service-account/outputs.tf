output "service_account_email" {
  description = "Email of the service account"
  value       = google_service_account.adf_service_account.email
}

output "service_account_id" {
  description = "ID of the service account"
  value       = google_service_account.adf_service_account.id
}

output "service_account_name" {
  description = "Name of the service account"
  value       = google_service_account.adf_service_account.name
}

output "service_account_unique_id" {
  description = "Unique ID of the service account"
  value       = google_service_account.adf_service_account.unique_id
}

output "service_account_key" {
  description = "Service account key (base64 encoded)"
  value       = var.create_service_account_key ? google_service_account_key.adf_service_account_key[0].private_key : null
  sensitive   = true
}

output "service_account_key_id" {
  description = "ID of the service account key"
  value       = var.create_service_account_key ? google_service_account_key.adf_service_account_key[0].id : null
}

output "workload_identity_pool_id" {
  description = "ID of the workload identity pool"
  value       = var.enable_workload_identity ? google_iam_workload_identity_pool.azure_pool[0].id : null
}

output "workload_identity_pool_name" {
  description = "Name of the workload identity pool"
  value       = var.enable_workload_identity ? google_iam_workload_identity_pool.azure_pool[0].name : null
}

output "workload_identity_provider_id" {
  description = "ID of the workload identity provider"
  value       = var.enable_workload_identity ? google_iam_workload_identity_pool_provider.azure_provider[0].id : null
}

output "workload_identity_provider_name" {
  description = "Name of the workload identity provider"
  value       = var.enable_workload_identity ? google_iam_workload_identity_pool_provider.azure_provider[0].name : null
}

output "bigquery_access_enabled" {
  description = "Whether BigQuery access is enabled"
  value       = var.enable_bigquery_access
}

output "analytics_access_enabled" {
  description = "Whether Google Analytics access is enabled"
  value       = var.enable_analytics_access
}

