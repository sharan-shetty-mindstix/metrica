output "dataset_id" {
  description = "ID of the GA4 BigQuery dataset"
  value       = google_bigquery_dataset.ga4_dataset.dataset_id
}

output "dataset_friendly_name" {
  description = "Friendly name of the GA4 BigQuery dataset"
  value       = google_bigquery_dataset.ga4_dataset.friendly_name
}

output "dataset_self_link" {
  description = "Self link of the GA4 BigQuery dataset"
  value       = google_bigquery_dataset.ga4_dataset.self_link
}

output "dataset_location" {
  description = "Location of the GA4 BigQuery dataset"
  value       = google_bigquery_dataset.ga4_dataset.location
}

output "events_table_id" {
  description = "ID of the GA4 events table"
  value       = var.create_ga4_events_table ? google_bigquery_table.ga4_events[0].table_id : null
}

output "events_table_self_link" {
  description = "Self link of the GA4 events table"
  value       = var.create_ga4_events_table ? google_bigquery_table.ga4_events[0].self_link : null
}

output "users_table_id" {
  description = "ID of the GA4 users table"
  value       = var.create_ga4_users_table ? google_bigquery_table.ga4_users[0].table_id : null
}

output "users_table_self_link" {
  description = "Self link of the GA4 users table"
  value       = var.create_ga4_users_table ? google_bigquery_table.ga4_users[0].self_link : null
}

output "sessions_table_id" {
  description = "ID of the GA4 sessions table"
  value       = var.create_ga4_sessions_table ? google_bigquery_table.ga4_sessions[0].table_id : null
}

output "sessions_table_self_link" {
  description = "Self link of the GA4 sessions table"
  value       = var.create_ga4_sessions_table ? google_bigquery_table.ga4_sessions[0].self_link : null
}

output "dataset_access_configured" {
  description = "Whether Azure Data Factory access is configured"
  value       = var.enable_adf_access
}

