output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.adls.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.adls.id
}

output "storage_account_primary_dfs_endpoint" {
  description = "Primary DFS endpoint for the storage account"
  value       = azurerm_storage_account.adls.primary_dfs_endpoint
}

output "storage_containers" {
  description = "Names of all storage containers"
  value = {
    raw    = azurerm_storage_container.raw.name
    bronze = azurerm_storage_container.bronze.name
    silver = azurerm_storage_container.silver.name
    gold   = azurerm_storage_container.gold.name
  }
}
