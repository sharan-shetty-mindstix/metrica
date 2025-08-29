data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  
  # Security settings
  public_network_access_enabled = false
  enable_rbac_authorization     = true
  
  # Network rules
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
  
  tags = var.tags
}

# Grant current user access to Key Vault
resource "azurerm_role_assignment" "key_vault_admin" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Store secrets (non-sensitive)
resource "azurerm_key_vault_secret" "secrets" {
  for_each = var.secrets
  
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.key_vault.id
  
  depends_on = [azurerm_role_assignment.key_vault_admin]
}

# Store GCP service account key separately to avoid sensitive value in for_each
resource "azurerm_key_vault_secret" "gcp_service_account_key" {
  count = var.gcp_service_account_key != null ? 1 : 0
  
  name         = "gcp-service-account-key"
  value        = var.gcp_service_account_key
  key_vault_id = azurerm_key_vault.key_vault.id
  
  depends_on = [azurerm_role_assignment.key_vault_admin]
}
