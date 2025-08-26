locals {
  type_of_resource = "func"

  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.short_name}-${var.naming_convention_properties.environment}${var.version_func}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.version_func}"
}

data "azurerm_storage_account" "data_lake_storage_account" {
   name = var.storage_account_name
   resource_group_name = var.resource_group_name
} 

resource "azurerm_app_service_plan" "app_service_plan" {
  name = "${local.final_resource_name}_app_service_plan"
  resource_group_name = var.resource_group_name
  location = var.location
  kind = var.kind 
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_application_insights" "appinsights" {
  name                = "${local.final_resource_name}_app_insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

resource "azurerm_function_app" "function_app" {
  name = local.final_resource_name
  location = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  storage_account_name = var.storage_account_name
  storage_account_access_key = data.azurerm_storage_account.data_lake_storage_account.primary_access_key
  os_type = var.os_type
  version = "~4"
  identity {
    type = var.identity_type
  }
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.appinsights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.appinsights.connection_string
    FUNCTIONS_WORKER_RUNTIME = var.Function_worker_runtime
  }
  site_config {

    linux_fx_version = var.kind == "Linux" ? var.linux_fx_version : null
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
  }
  tags = var.tags
}