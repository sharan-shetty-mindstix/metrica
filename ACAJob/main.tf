locals {
  type_of_resource = "ca"

  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.short_name}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"

}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.naming_convention_properties.subscription_name}-dapl-log-${var.naming_convention_properties.environment}01"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.retention_in_days
   tags = var.tags
}

resource "azurerm_container_app_environment" "app_env" {
  name                       = "${var.naming_convention_properties.subscription_name}-dapl-cae-${var.naming_convention_properties.environment}01"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
   tags = var.tags
}

resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  location            = var.location
  name                = "${var.naming_convention_properties.subscription_name}-dapl-id-acr-${var.naming_convention_properties.environment}01"
  resource_group_name = var.resource_group_name
}

resource "azurerm_container_app_job" "container_app_job" {
  name                         = local.final_resource_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.app_env.id
  schedule_trigger_config {
    cron_expression = var.cron_expression
  }
  dynamic secret {
    for_each = var.secrets
    content{    
      name = secret.value.aca_secret_name
      identity = secret.value.secret_id != null ? azurerm_user_assigned_identity.user_assigned_identity.id : null
      key_vault_secret_id = try(secret.value.secret_id)
      value = try(secret.value.secret_value)
     }
    }
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.user_assigned_identity.id]
  }
  registry {
    identity = azurerm_user_assigned_identity.user_assigned_identity.id
    server = var.registry_server
  }
  template {
    dynamic "container" {
       for_each = var.container
      content {
        name   = container.value.name
        image  = container.value.image
        cpu    = container.value.cpu
        memory = container.value.memory

        dynamic "env" {
          for_each = container.value.env_vars != null ? container.value.env_vars : []
          content {
            name        = env.value.name
            value       = try(env.value.value, null)
            secret_name = try(env.value.secret_name, null)
          }
        }
      }
    }
  }
  replica_timeout_in_seconds = 1800
  replica_retry_limit        = 0
  tags = var.tags
}
