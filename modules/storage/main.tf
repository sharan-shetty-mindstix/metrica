# Storage Account for Data Lake Storage Gen2
resource "azurerm_storage_account" "adls" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = "StorageV2"
  is_hns_enabled          = true

  tags = var.tags
}

# Storage Containers (configurable via list)
variable "container_names" {
  type        = list(string)
  description = "List of ADLS container names to create."
  default     = ["raw", "bronze", "silver", "gold"]
}

resource "azurerm_storage_container" "containers" {
  for_each              = toset(var.container_names)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"
}
