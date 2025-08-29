variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "account_id" {
  description = "Service account ID"
  type        = string
}

variable "display_name" {
  description = "Display name for the service account"
  type        = string
}

variable "description" {
  description = "Description for the service account"
  type        = string
  default     = "Service account for data pipeline integration"
}

variable "bucket_permissions" {
  description = "List of storage permissions to grant"
  type        = list(string)
  default     = ["objectViewer", "objectCreator", "objectAdmin"]
}

variable "buckets" {
  description = "List of bucket names to grant permissions to"
  type        = list(string)
  default     = []
}
