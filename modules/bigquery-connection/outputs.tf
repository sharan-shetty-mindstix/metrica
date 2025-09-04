output "bigquery_linked_service_name" {
  description = "Name of the BigQuery linked service"
  value       = azurerm_data_factory_linked_service_web.bigquery_linked_service.name
}

output "bigquery_linked_service_id" {
  description = "ID of the BigQuery linked service"
  value       = azurerm_data_factory_linked_service_web.bigquery_linked_service.id
}

output "bigquery_oauth_linked_service_name" {
  description = "Name of the BigQuery OAuth linked service"
  value       = var.use_oauth2_authentication ? azurerm_data_factory_linked_service_web.bigquery_oauth_linked_service[0].name : null
}

output "bigquery_oauth_linked_service_id" {
  description = "ID of the BigQuery OAuth linked service"
  value       = var.use_oauth2_authentication ? azurerm_data_factory_linked_service_web.bigquery_oauth_linked_service[0].id : null
}
