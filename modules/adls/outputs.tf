output "account_name" {
  description = "Name of the Azure Data Lake Storage account"
  value       = azurerm_storage_account.adls.name
}

output "account_id" {
  description = "ID of the Azure Data Lake Storage account"
  value       = azurerm_storage_account.adls.id
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint"
  value       = azurerm_storage_account.adls.primary_blob_endpoint
}

output "containers" {
  description = "Map of container names and their properties"
  value = {
    for name, container in azurerm_storage_container.containers : name => {
      name = container.name
      id   = container.id
    }
  }
}
