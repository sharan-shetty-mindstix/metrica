# Production Environment Configuration
project_name = "metrica"
environment  = "prod"

# Azure Configuration
azure_location = "eastus"

# Google Cloud Configuration
gcp_project_id = "your-gcp-project-id"
gcp_region     = "us-central1"

# GitHub Configuration
github_repository_name = "data-pipeline"
github_account_name    = "your-github-org"

# Phase 2 - Networking Configuration
vnet_address_space = ["10.1.0.0/16"]

subnets = {
  app = {
    target_resource_type = "app"
    address_prefixes     = ["10.1.1.0/24"]
    service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"]
  }
  data = {
    target_resource_type = "data"
    address_prefixes     = ["10.1.2.0/24"]
    service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"]
  }
  pe = {
    target_resource_type = "pe"
    address_prefixes     = ["10.1.3.0/24"]
    service_endpoints    = ["Microsoft.KeyVault", "Microsoft.Storage", "Microsoft.Sql"]
  }
}

# Phase 2 - Key Vault Configuration
key_vault_sku = "standard"
key_vault_soft_delete_retention_days = 30
key_vault_purge_protection_enabled = true
key_vault_enable_rbac = true
key_vault_public_network_access_enabled = false
