# Azure Subnet Module
locals {
  subnet_resources = "snet" # Define a constant for subnet resource naming

  # Generate subnet names dynamically using a map based on input subnets
  subnet_names = { 
    for subnet_key, subnet_value in var.subnets :
    subnet_key => "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.subnet_resources}-${subnet_value.target_resource_type}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"
  }
}

data "azurerm_resource_group" "ssvc_rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "existing_vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
# Resource: azurerm_subnet - Defines the Azure Subnets within the Virtual Network
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets # Iterate over the subnets variable to create multiple subnets

  name                 = local.subnet_names[each.key]
  resource_group_name  = data.azurerm_resource_group.ssvc_rg.name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  address_prefixes     = each.value.address_prefixes
  
  # Optional configurations - only set if provided
  service_endpoints                             = lookup(each.value, "service_endpoints", null)
  service_endpoint_policy_ids                   = lookup(each.value, "service_endpoint_policy_ids", null)
  private_endpoint_network_policies             = lookup(each.value, "private_endpoint_network_policies", "Disabled")
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", true)
  default_outbound_access_enabled               = lookup(each.value, "default_outbound_access_enabled", true)

  # Dynamic block for subnet delegation, if applicable
dynamic "delegation" {
  for_each = lookup(each.value, "delegations", []) != null ? lookup(each.value, "delegations", []) : []
  content {
    name = delegation.value.name

    service_delegation {
      name    = delegation.value.service_delegation.name
      actions = lookup(delegation.value.service_delegation, "actions", null)
    }
  }
}
}