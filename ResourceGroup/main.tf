locals {
  type_of_resource = "rg"

  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.short_name}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/resource_group
resource "azurerm_resource_group" "resource_group" {
  name     = local.final_resource_name
  location = var.location
  tags     = var.tags
}