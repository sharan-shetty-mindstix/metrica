variable "name" {
  description = "Name of the Azure Data Factory"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the data factory"
  type        = string
}

variable "github_configuration" {
  description = "GitHub configuration for CI/CD"
  type = object({
    repository_name = string
    root_folder     = string
    branch_name     = string
    account_name    = string
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to the data factory"
  type        = map(string)
  default     = {}
}
