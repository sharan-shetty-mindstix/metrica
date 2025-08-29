variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "location" {
  description = "Default location for GCS buckets"
  type        = string
}

variable "buckets" {
  description = "Map of bucket configurations"
  type = map(object({
    name                = string
    location            = string
    force_destroy       = optional(bool, false)
    versioning_enabled  = optional(bool, true)
    lifecycle_rules     = optional(list(object({
      age        = number
      action_type = string
    })), [])
    labels              = optional(map(string), {})
  }))
}

variable "common_labels" {
  description = "Common labels to apply to all buckets"
  type        = map(string)
  default     = {}
}
