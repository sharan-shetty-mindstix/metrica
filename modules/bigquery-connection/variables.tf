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

