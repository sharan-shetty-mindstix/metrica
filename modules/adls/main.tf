resource "azurerm_storage_account" "adls" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  is_hns_enabled           = var.is_hns_enabled
  
  # Security settings
  public_network_access_enabled = false
  allow_nested_items_to_be_public = false
  shared_access_key_enabled = false
  default_to_oauth_authentication = true
  
  # Encryption
  infrastructure_encryption_enabled = true
  
  # Network rules
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }
  
  tags = var.tags
}

resource "azurerm_storage_container" "containers" {
  for_each = var.containers
  
  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = each.value.access_type
}
