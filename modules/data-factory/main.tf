# Azure Data Factory
resource "azurerm_data_factory" "adf" {
  name                = var.data_factory_name
  location            = var.location
  resource_group_name = var.resource_group_name

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Data Factory Linked Service for Azure Data Lake Storage
resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "adls_linked_service" {
  name                 = "AzureDataLakeStorageGen2"
  data_factory_id      = azurerm_data_factory.adf.id
  service_principal_id = azurerm_data_factory.adf.identity[0].principal_id
  service_principal_key = azurerm_data_factory.adf.identity[0].principal_id
  tenant               = var.tenant_id
  url                  = var.storage_endpoint
}

# GA4 Data Extraction Pipeline
resource "azurerm_data_factory_pipeline" "ga4_data_pipeline" {
  name                = "GA4DataExtractionPipeline"
  data_factory_id     = azurerm_data_factory.adf.id

  description = "Pipeline for extracting GA4 data from BigQuery and loading to ADLS"
  
  annotations = [
    "GA4 Data",
    "BigQuery",
    "Analytics"
  ]
}

# GA4 Data Processing Pipeline (Bronze to Silver)
resource "azurerm_data_factory_pipeline" "ga4_processing_pipeline" {
  name                = "GA4DataProcessingPipeline"
  data_factory_id     = azurerm_data_factory.adf.id

  description = "Pipeline for processing GA4 data from Bronze to Silver layer"
  
  annotations = [
    "GA4 Data",
    "Data Processing",
    "Bronze to Silver"
  ]
}

# GA4 Analytics Pipeline (Silver to Gold)
resource "azurerm_data_factory_pipeline" "ga4_analytics_pipeline" {
  name                = "GA4AnalyticsPipeline"
  data_factory_id     = azurerm_data_factory.adf.id

  description = "Pipeline for creating GA4 analytics and KPI tables"
  
  annotations = [
    "GA4 Data",
    "Analytics",
    "Silver to Gold"
  ]
}
