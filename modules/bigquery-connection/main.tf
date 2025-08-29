# BigQuery Linked Service for Azure Data Factory
resource "azurerm_data_factory_linked_service_azure_sql_database" "bigquery_linked_service" {
  name                 = "GoogleBigQuery"
  data_factory_id      = var.data_factory_id
  connection_string    = "Server=tcp:bigquery.googleapis.com,1433;Database=${var.gcp_project_id};Authentication=Active Directory Service Principal;Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
}
