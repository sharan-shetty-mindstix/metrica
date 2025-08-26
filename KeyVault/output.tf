output "key_vault_id" {
  value       = azurerm_key_vault.key_vault.id # Replace 'example' with your resource name in the module
  description = "The ID of the Azure Key Vault"
}
