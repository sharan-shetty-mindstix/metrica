output "key_vault_name" {
  description = "Name of the key vault"
  value       = azurerm_key_vault.akv.name
}

output "key_vault_id" {
  description = "ID of the key vault"
  value       = azurerm_key_vault.akv.id
}

output "key_vault_uri" {
  description = "URI of the key vault"
  value       = azurerm_key_vault.akv.vault_uri
}
