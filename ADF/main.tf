locals {
  type_of_resource = "adf"

  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.short_name}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"

}

# data "azurerm_key_vault" "key_vault" {
#   name                = var.key_vault_name
#   resource_group_name = var.resource_group_name
# }

# data "azurerm_storage_account" "storage_account_data_lake"{
#   name = var.storage_account_name
#   resource_group_name =var.resource_group_name
# }

resource "azurerm_data_factory" "data_factory" {
  name                = local.final_resource_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dynamic "github_configuration" {
    for_each = var.github_configurations != null ? [1] : []
    content {
      repository_name = var.github_configurations.repository_name
      root_folder     = var.github_configurations.root_folder
      branch_name     = var.github_configurations.branch_name
      account_name    = var.github_configurations.account_name
    }
  }
  public_network_enabled          = var.public_network_enabled
  managed_virtual_network_enabled = var.managed_virtual_network_enabled
  identity {
    type = var.identity
  }
  tags = var.tags
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "data_factory_self_hosted_integration" {
  for_each        = var.data_factory_self_hosted_integration_config != null ? var.data_factory_self_hosted_integration_config : {}
  name            = each.value.name
  data_factory_id = azurerm_data_factory.data_factory.id
  description     = lookup(each.value, "self_hosted_description", null)
  dynamic "rbac_authorization" {
    for_each = each.value.rbac_authorization != null ? [each.value.rbac_authorization] : []
    content {
      resource_id = each.value.rbac_authorization.resource_id
    }
  }
}

# resource "azurerm_data_factory_linked_service_key_vault" "key_vault_linked_service" {
#   name                     = var.key_vault_name
#   key_vault_id             = data.azurerm_key_vault.key_vault.id
#   data_factory_id          = azurerm_data_factory.data_factory.id
#   integration_runtime_name = azurerm_data_factory_integration_runtime_self_hosted.data_factory_self_hosted_integration[0].name
#   description              = var.key_vault_linked_service_description
# }

# resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "data_lake_genv2" {
#   name =  var.storage_account_name
#   url =  data.azurerm_storage_account.storage_account_data_lake.url

#   data_factory_id = data.azurerm_storage_account.storage_account_data_lake.id
#   integration_runtime_name = azurerm_data_factory_integration_runtime_self_hosted.data_factory_self_hosted_integration[0].name
# }