locals {
  type_of_resource = "mysql"

  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.short_name}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"

  # Determine the admin password based on input variables
  admin_password_mysql = random_password.admin_password.result

  # Generate the expiration date for the secret in AKV (if applicable)
  generated_secret_expiration_date_utc = var.generated_secrets_key_vault_secret_config != null ? formatdate("YYYY-MM-DD'T'hh:mm:ssZ", timeadd(time_static.secret_creation_time.rfc3339, "${var.generated_secrets_key_vault_secret_config.expiration_date_length_in_days * 24}h")) : null
}

resource "time_static" "secret_creation_time" {
  depends_on = [random_password.admin_password]
}

data "azurerm_mysql_flexible_server" "primary_db" {
  count               = var.create_mode == "Replica" ? 1 : 0
  name                = var.primary_mysql_db_name
  resource_group_name = var.primary_mysql_db_rg
}

data "azurerm_resource_group" "ssvc_resource_group" {
  name = var.ssvc_resource_group_name
}

data "azurerm_virtual_network" "existing_vnet" {
  count               = var.vnet_name != "" ? 1 : 0
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.ssvc_resource_group.name
}

data "azurerm_subnet" "existing_subnet" {
  count                = var.subnet_name != "" && var.vnet_name != "" ? 1 : 0
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.ssvc_resource_group.name
}


# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "admin_password" {
  length           = 22
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  override_special = "!#$%&()*+,-./:;<=>?@[]^_{|}~"
  special          = true
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret
resource "azurerm_key_vault_secret" "mysql_admin_password" {
  count           = var.generated_secrets_key_vault_secret_config != null ? 1 : 0
  name            = var.generated_secrets_key_vault_secret_config.name
  value           = local.admin_password_mysql
  key_vault_id    = var.generated_secrets_key_vault_secret_config.key_vault_resource_id
  expiration_date = local.generated_secret_expiration_date_utc

  depends_on = [random_password.admin_password]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/mysql_flexible_server
resource "azurerm_mysql_flexible_server" "mysql_db" {
  name                = local.final_resource_name
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = var.mysql_version
  sku_name            = var.sku_name

  administrator_login    = var.admin_username
  administrator_password = local.admin_password_mysql

  zone                = var.db_zone
  delegated_subnet_id = var.subnet_id != "" ? var.subnet_id : data.azurerm_subnet.existing_subnet[0].id
  private_dns_zone_id = var.private_dns_zone_id


  dynamic "storage" {
    for_each = var.storage[*]
    content {
      auto_grow_enabled  = var.storage.auto_grow_enabled
      size_gb            = var.storage.size_gb
      io_scaling_enabled = var.storage.io_scaling_enabled
      iops               = var.storage.iops
    }
  }


  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup
  create_mode                       = var.create_mode
  source_server_id = var.create_mode == "Replica" ? data.azurerm_mysql_flexible_server.primary_db[0].id : null

  dynamic "high_availability" {
    for_each = var.high_availability == null ? [] : [var.high_availability]
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  tags = var.tags

  depends_on = [azurerm_key_vault_secret.mysql_admin_password]


}



