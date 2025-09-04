# GCP Configuration
variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

# Service Account Configuration
variable "service_account_id" {
  description = "ID of the service account"
  type        = string
  default     = "adf-ga4-integration"
}

variable "service_account_display_name" {
  description = "Display name of the service account"
  type        = string
  default     = "Azure Data Factory GA4 Integration"
}

variable "service_account_description" {
  description = "Description of the service account"
  type        = string
  default     = "Service account for Azure Data Factory to access GA4 and BigQuery data"
}

variable "create_service_account_key" {
  description = "Whether to create a service account key"
  type        = bool
  default     = true
}

# IAM Permissions
variable "enable_bigquery_access" {
  description = "Whether to enable BigQuery access"
  type        = bool
  default     = true
}

variable "enable_bigquery_data_editor" {
  description = "Whether to enable BigQuery data editor access"
  type        = bool
  default     = false
}

variable "enable_storage_access" {
  description = "Whether to enable Cloud Storage access"
  type        = bool
  default     = false
}

variable "enable_analytics_access" {
  description = "Whether to enable Google Analytics access"
  type        = bool
  default     = true
}

# Workload Identity Configuration
variable "enable_workload_identity" {
  description = "Whether to enable Workload Identity for Azure integration"
  type        = bool
  default     = false
}

variable "workload_identity_pool_id" {
  description = "ID of the workload identity pool"
  type        = string
  default     = "azure-adf-pool"
}

variable "workload_identity_pool_display_name" {
  description = "Display name of the workload identity pool"
  type        = string
  default     = "Azure Data Factory Pool"
}

variable "workload_identity_pool_description" {
  description = "Description of the workload identity pool"
  type        = string
  default     = "Workload Identity pool for Azure Data Factory integration"
}

variable "workload_identity_provider_id" {
  description = "ID of the workload identity provider"
  type        = string
  default     = "azure-adf-provider"
}

variable "workload_identity_provider_display_name" {
  description = "Display name of the workload identity provider"
  type        = string
  default     = "Azure Data Factory Provider"
}

variable "workload_identity_provider_description" {
  description = "Description of the workload identity provider"
  type        = string
  default     = "Workload Identity provider for Azure Data Factory"
}

# Azure Configuration
variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

