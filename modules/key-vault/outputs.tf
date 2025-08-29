output "name" {
  description = "Name of the Azure Key Vault"
  value       = azurerm_key_vault.key_vault.name
}

output "id" {
  description = "ID of the Azure Key Vault"
  value       = azurerm_key_vault.key_vault.id
}

output "uri" {
  description = "URI of the Azure Key Vault"
  value       = azurerm_key_vault.key_vault.vault_uri
}
