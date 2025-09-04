# BigQuery Linked Service for Azure Data Factory using JSON configuration
resource "azurerm_data_factory_linked_service_web" "bigquery_linked_service" {
  name            = "GoogleBigQuery"
  data_factory_id = var.data_factory_id
  url             = "https://bigquery.googleapis.com/bigquery/v2/projects/${var.gcp_project_id}"
  authentication_type = "Anonymous"
  
  description = "Linked service for Google BigQuery integration with GA4 data"
  
  additional_properties = {
    "authenticationType" = "ServicePrincipal"
    "url" = "https://bigquery.googleapis.com/bigquery/v2/projects/${var.gcp_project_id}"
    "servicePrincipalId" = var.gcp_client_id
    "servicePrincipalKey" = var.gcp_private_key
    "tenant" = var.gcp_tenant_id
  }
}

# Alternative: BigQuery Linked Service using OAuth2 (if preferred)
resource "azurerm_data_factory_linked_service_web" "bigquery_oauth_linked_service" {
  count            = var.use_oauth2_authentication ? 1 : 0
  name            = "GoogleBigQueryOAuth"
  data_factory_id = var.data_factory_id
  url             = "https://bigquery.googleapis.com/bigquery/v2/projects/${var.gcp_project_id}"
  authentication_type = "Anonymous"
  
  description = "Linked service for Google BigQuery using OAuth2 authentication"
  
  additional_properties = {
    "authenticationType" = "OAuth2"
    "url" = "https://bigquery.googleapis.com/bigquery/v2/projects/${var.gcp_project_id}"
    "authorization" = "Bearer"
  }
}
