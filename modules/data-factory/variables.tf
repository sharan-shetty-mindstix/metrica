variable "data_factory_name" {
  description = "Name of the Azure Data Factory"
  type        = string
}

variable "location" {
  description = "Azure region for the Data Factory"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "storage_endpoint" {
  description = "Storage account endpoint for Data Lake Storage"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Data Factory"
  type        = map(string)
  default     = {}
}
