locals {
  # Define the type of resource as 'pep' (private endpoint)
  type_of_resource = "pep"

  # Define the final name for the virtual machine resource based on the naming convention
  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.short_name}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"
  
  private_service_connection_name  = "${local.final_resource_name}-private_connection"
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name = local.final_resource_name
  location = var.location
  resource_group_name = var.resource_group_name
  subnet_id = var.subnet_id

  private_service_connection {
    name = local.private_service_connection_name
    is_manual_connection = var.is_manual_connection
    subresource_names  = var.subresource_names
    private_connection_resource_id = var.private_connection_resource_id
  }
  # private_dns_zone_group {
  #   name = "${local.final_resource_name}-dns_zone_group"
  #   private_dns_zone_ids = var.private_dns_zone_ids
  # }

  tags = var.tags
}