locals {
  # Define the type of resource as 'vm' (virtual machine)
  type_of_resource = "sql"

  # Define the final name for the virtual machine resource based on the naming convention
  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.short_name}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"

}

resource "azurerm_mssql_server" "sql_server" {
  name                         = local.final_resource_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  identity {
    type = var.identity
  }
  minimum_tls_version                  = var.minimum_tls_version
  public_network_access_enabled        = var.public_network_access_enabled
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled
  tags                                 = var.tags
}

resource "azurerm_mssql_elasticpool" "elastic_pool" {
  for_each = var.elastic_pool_configs != null ? var.elastic_pool_configs : {}

  name                = each.value.elastic_pool_name
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_mssql_server.sql_server.name
  sku {
    name     = each.value.elastic_pool_sku
    tier     = each.value.elastic_pool_tier
    capacity = each.value.elastic_pool_capacity
    family   = each.value.elastic_pool_family
  }
      max_size_gb = each.value.elastic_max_size_gb
  per_database_settings {
    min_capacity = each.value.min_capacity
    max_capacity = each.value.max_capacity
  }
  depends_on = [azurerm_mssql_server.sql_server]
}

resource "azurerm_mssql_database" "sql_database" {
  for_each          = var.sql_databases != null ? var.sql_databases : {}
  name              = each.value.database_name
  server_id         = azurerm_mssql_server.sql_server.id
  collation         = each.value.collation
  elastic_pool_id   = each.value.elastic_pool_name != null ? azurerm_mssql_elasticpool.elastic_pool[each.value.elastic_pool_name].id : null
  sku_name = each.value.elastic_pool_name!=null ? null : each.value.database_sku_name
  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids != null ? identity.value.identity_ids : []
    }
  }
  # prevent the possibility of accidental data loss
  lifecycle {
    # prevent_destroy = true
  }
  tags = var.tags

  depends_on = [azurerm_mssql_elasticpool.elastic_pool]
}
