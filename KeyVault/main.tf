locals {
  type_of_resource = "kv"

  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.short_name}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/data-sources/client_config
data "azurerm_client_config" "current" {}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/key_vault
resource "azurerm_key_vault" "key_vault" {
  name                            = local.final_resource_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = var.sku_name
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  enable_rbac_authorization       = var.enable_rbac_authorization
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  public_network_access_enabled   = var.public_network_access_enabled

  dynamic "access_policy" {
    for_each = var.access_policies != null ? var.access_policies : {}
    content {
      tenant_id           = data.azurerm_client_config.current.tenant_id
      object_id           = access_policy.value.object_id
      key_permissions     = access_policy.value.key_permissions
      secret_permissions  = access_policy.value.secret_permissions
      storage_permissions = access_policy.value.storage_permissions
      certificate_permissions = access_policy.value.certificate_permissions
    }
  }


  tags = var.tags
}



