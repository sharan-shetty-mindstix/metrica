resource "azurerm_data_factory" "adf" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  
  # GitHub integration for CI/CD
  dynamic "github_configuration" {
    for_each = var.github_configuration != null ? [var.github_configuration] : []
    content {
      repository_name = github_configuration.value.repository_name
      root_folder     = github_configuration.value.root_folder
      branch_name     = github_configuration.value.branch_name
      account_name    = github_configuration.value.account_name
    }
  }
  
  # Security settings
  public_network_enabled = false
  managed_virtual_network_enabled = true
  
  # Identity
  identity {
    type = "SystemAssigned"
  }
  
  tags = var.tags
}
