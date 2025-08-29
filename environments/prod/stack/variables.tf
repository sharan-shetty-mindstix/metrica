# Project Configuration
variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "metrica"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
  validation {
    condition     = var.environment == "prod"
    error_message = "This configuration is for prod environment only."
  }
}

# Azure Configuration
variable "azure_location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"
  validation {
    condition     = can(regex("^[a-z]+[a-z0-9]*$", var.azure_location))
    error_message = "Location must be a valid Azure region name."
  }
}

# Google Cloud Configuration
variable "gcp_project_id" {
  description = "Google Cloud Project ID"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.gcp_project_id))
    error_message = "GCP Project ID must be 6-30 characters, start with a letter, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "gcp_region" {
  description = "Google Cloud region for resources"
  type        = string
  default     = "us-central1"
  validation {
    condition     = can(regex("^[a-z]+[a-z0-9-]*$", var.gcp_region))
    error_message = "GCP region must be a valid region name."
  }
}

# GitHub Configuration for ADF CI/CD
variable "github_repository_name" {
  description = "GitHub repository name for ADF CI/CD"
  type        = string
  default     = "data-pipeline"
}

variable "github_account_name" {
  description = "GitHub account/organization name"
  type        = string
  default     = "your-github-org"
}
