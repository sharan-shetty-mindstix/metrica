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
  value       = [for c in azurerm_storage_container.containers : c.name]
}
