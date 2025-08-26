# Local variables for naming convention and resource details
locals {
  type_of_resource = "vnet" # Define the type of resource (in this case, virtual network)

  # Define the final name of the virtual network resource, depending on whether a short name is provided
  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.short_name}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"

  subnet_resources = "snet" # Define a constant for subnet resource naming

  subnet_names = { # Generate subnet names dynamically using a map based on input subnets
    for subnet_key, subnet_value in var.subnets :
    subnet_key => "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.subnet_resources}-${subnet_value.target_resource_type}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"
  }
}

data "azurerm_resource_group" "ssvc_rg" {
  name = var.resource_group_name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/virtual_network
# Resource: azurerm_virtual_network - Defines the Azure Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = local.final_resource_name # Name of the VNet derived from the local final resource name
  address_space       = var.address_space         # Address space for the VNet (can be an array of CIDR blocks)   
  location            = var.location              # Azure region where the VNet will be created
  resource_group_name = data.azurerm_resource_group.ssvc_rg.name   # The resource group where the VNet will reside
  tags                = var.tags                  # Tags to apply to the VNet for management and organization
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/subnet
# Resource: azurerm_subnet - Defines the Azure Subnets within the Virtual Network
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets # Iterate over the subnets variable to create multiple subnets

  name                 = local.subnet_names[each.key]      # Name of the subnet, generated using the naming convention
  resource_group_name  = data.azurerm_resource_group.ssvc_rg.name           # Resource group where the subnet will reside (same as VNet)
  virtual_network_name = azurerm_virtual_network.vnet.name # Name of the VNet this subnet will be associated with
  address_prefixes     = each.value.address_prefixes       # Address prefixes for the subnet (e.g., CIDR blocks)
  service_endpoints    = each.value.service_endpoints      # Service endpoints to enable for this subnet (if any)

  dynamic "delegation" { # Dynamic block for subnet delegation, if applicable
    for_each = each.value.delegations != null ? each.value.delegations : []
    content {
      name = delegation.value.name # The delegation name

      service_delegation { # Service delegation information
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}
