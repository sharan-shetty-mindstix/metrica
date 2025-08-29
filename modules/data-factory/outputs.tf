output "data_factory_name" {
  description = "Name of the data factory"
  value       = azurerm_data_factory.adf.name
}

output "data_factory_id" {
  description = "ID of the data factory"
  value       = azurerm_data_factory.adf.id
}

output "data_factory_identity" {
  description = "Identity information for the data factory"
  value = {
    principal_id = azurerm_data_factory.adf.identity[0].principal_id
    tenant_id    = azurerm_data_factory.adf.identity[0].tenant_id
  }
}

output "linked_services" {
  description = "Names of all linked services"
  value = {
    adls2 = azurerm_data_factory_linked_service_data_lake_storage_gen2.adls_linked_service.name
  }
}

output "pipeline_name" {
  description = "Name of the data ingestion pipeline"
  value       = azurerm_data_factory_pipeline.data_ingestion_pipeline.name
}
