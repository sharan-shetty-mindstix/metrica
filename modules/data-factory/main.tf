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

# Data Factory Pipeline for data processing
resource "azurerm_data_factory_pipeline" "data_ingestion_pipeline" {
  name                = "DataIngestionPipeline"
  data_factory_id     = azurerm_data_factory.adf.id

  activities_json = jsonencode([
    {
      name = "ProcessDataInADLS"
      type = "Copy"
      typeProperties = {
        source = {
          type = "AzureDataLakeStoreSource"
          folderPath = "raw"
        }
        sink = {
          type = "AzureDataLakeStoreSink"
          folderPath = "processed"
        }
      }
    }
  ])
}
