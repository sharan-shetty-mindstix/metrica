output "bigquery_linked_service_name" {
  description = "Name of the BigQuery linked service"
  value       = azurerm_data_factory_linked_service_azure_blob_storage.bigquery_linked_service.name
}

output "bigquery_linked_service_id" {
  description = "ID of the BigQuery linked service"
  value       = azurerm_data_factory_linked_service_azure_blob_storage.bigquery_linked_service.id
}
