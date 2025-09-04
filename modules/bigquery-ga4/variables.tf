# GCP Configuration
variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

# GA4 Dataset Configuration
variable "ga4_dataset_id" {
  description = "BigQuery dataset ID for GA4 data"
  type        = string
  default     = "ga4_data"
}

variable "ga4_dataset_friendly_name" {
  description = "Friendly name for the GA4 dataset"
  type        = string
  default     = "GA4 Analytics Data"
}

variable "ga4_dataset_description" {
  description = "Description for the GA4 dataset"
  type        = string
  default     = "Dataset containing Google Analytics 4 data for analytics and reporting"
}

# Table Configuration
variable "create_ga4_events_table" {
  description = "Whether to create the GA4 events table"
  type        = bool
  default     = true
}

variable "create_ga4_users_table" {
  description = "Whether to create the GA4 users table"
  type        = bool
  default     = true
}

variable "create_ga4_sessions_table" {
  description = "Whether to create the GA4 sessions table"
  type        = bool
  default     = true
}

variable "ga4_events_table_id" {
  description = "BigQuery table ID for GA4 events"
  type        = string
  default     = "events"
}

variable "ga4_users_table_id" {
  description = "BigQuery table ID for GA4 users"
  type        = string
  default     = "users"
}

variable "ga4_sessions_table_id" {
  description = "BigQuery table ID for GA4 sessions"
  type        = string
  default     = "sessions"
}

# Expiration Configuration
variable "default_table_expiration_ms" {
  description = "Default table expiration time in milliseconds"
  type        = number
  default     = 2592000000 # 30 days
}

variable "default_partition_expiration_ms" {
  description = "Default partition expiration time in milliseconds"
  type        = number
  default     = 5184000000 # 60 days (max for free tier)
}

variable "partition_expiration_ms" {
  description = "Partition expiration time in milliseconds"
  type        = number
  default     = 5184000000 # 60 days (max for free tier)
}

# Deletion Protection
variable "delete_contents_on_destroy" {
  description = "Whether to delete contents on destroy"
  type        = bool
  default     = false
}

variable "table_deletion_protection" {
  description = "Whether to enable deletion protection for tables"
  type        = bool
  default     = false
}

# Labels
variable "dataset_labels" {
  description = "Labels for the dataset"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "ga4-analytics"
    managed_by  = "terraform"
  }
}

variable "table_labels" {
  description = "Labels for the tables"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "ga4-analytics"
    managed_by  = "terraform"
  }
}

# Azure Data Factory Access
variable "enable_adf_access" {
  description = "Whether to enable Azure Data Factory access to the dataset"
  type        = bool
  default     = true
}

variable "adf_service_account_email" {
  description = "Azure Data Factory service account email"
  type        = string
  default     = ""
}

