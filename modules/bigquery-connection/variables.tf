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

variable "gcp_tenant_id" {
  description = "GCP tenant ID (for service principal authentication)"
  type        = string
  default     = ""
}

variable "use_oauth2_authentication" {
  description = "Whether to use OAuth2 authentication instead of service principal"
  type        = bool
  default     = false
}

variable "oauth2_client_id" {
  description = "OAuth2 client ID"
  type        = string
  default     = ""
}

variable "oauth2_client_secret" {
  description = "OAuth2 client secret"
  type        = string
  sensitive   = true
  default     = ""
}

variable "oauth2_tenant_id" {
  description = "OAuth2 tenant ID"
  type        = string
  default     = ""
}

