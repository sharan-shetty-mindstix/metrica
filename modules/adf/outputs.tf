output "name" {
  description = "Name of the Azure Data Factory"
  value       = azurerm_data_factory.adf.name
}

output "id" {
  description = "ID of the Azure Data Factory"
  value       = azurerm_data_factory.adf.id
}

output "identity" {
  description = "Identity configuration of the data factory"
  value       = azurerm_data_factory.adf.identity
}
