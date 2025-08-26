variable "resource_name" {
  type    = string
  default = ""
}

variable "naming_convention_properties" {
  description = "Properties for naming convention"
  type = object({
    subscription_name = string
    environment       = string
    version           = optional(string, "01")
  })
}

variable "project_code" {
  description = "Provide application/resource project code for the resource"
  type        = string
  default     = ""
}

variable "short_name" {
  description = "Provide application/resource short name for the resource"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Map of tags."
  type        = map(string)
}

variable "location" {
  description = "Map of tags."
  type        = string
}