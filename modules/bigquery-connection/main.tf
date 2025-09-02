# BigQuery Linked Service for Azure Data Factory
resource "azurerm_data_factory_linked_service_azure_blob_storage" "bigquery_linked_service" {
  name                 = "GoogleBigQuery"
  data_factory_id      = var.data_factory_id
  
  service_endpoint     = "https://storage.googleapis.com"
  
  service_principal_id = var.service_principal_id
  service_principal_key = var.service_principal_key
  tenant_id            = var.tenant_id
  
  # BigQuery connection properties
  additional_properties = {
    "serviceAccountEmail" = var.gcp_service_account_email
    "projectId"          = var.gcp_project_id
    "dataset"            = var.bigquery_dataset
  }
}
