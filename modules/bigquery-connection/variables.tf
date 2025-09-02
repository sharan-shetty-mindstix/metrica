variable "data_factory_id" {
  description = "ID of the Azure Data Factory"
  type        = string
}

variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_service_account_email" {
  description = "GCP service account email"
  type        = string
}

variable "gcp_private_key" {
  description = "GCP private key"
  type        = string
  sensitive   = true
}

variable "gcp_client_id" {
  description = "GCP client ID"
  type        = string
}

variable "service_principal_id" {
  description = "Azure service principal ID for authentication"
  type        = string
}

variable "service_principal_key" {
  description = "Azure service principal key for authentication"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "bigquery_dataset" {
  description = "BigQuery dataset name"
  type        = string
}