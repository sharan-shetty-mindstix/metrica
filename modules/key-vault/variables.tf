variable "name" {
  description = "Name of the Azure Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the key vault"
  type        = string
}

variable "secrets" {
  description = "Map of secret names and values"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to the key vault"
  type        = map(string)
  default     = {}
}

variable "gcp_service_account_key" {
  description = "GCP service account private key to store in Key Vault"
  type        = string
  default     = null
  sensitive   = true
}
