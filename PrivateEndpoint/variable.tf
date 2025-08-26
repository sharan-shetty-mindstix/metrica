variable "naming_convention_properties" {
  description = "Properties for naming convention"
  type = object({
    subscription_name = string
    environment       = string
    version           = optional(string, "01") # Default version is "01"
  })
}

variable "project_code" {
  description = "Provide application/resource project code for the resource"
  type        = string
  default     = "dapl" # Default is an empty string, so it's optional
}

variable "short_name" {
  description = "Provide application/resource short name for the resource"
  type        = string
  default     = "" # Default is an empty string, so it's optional
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Name of region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the resource."
  type        = string
}

variable "is_manual_connection" {
  description = "Manual connection for the resource"
  type        = bool
  default = false
}


variable "private_connection_resource_id" {
  description = "Id of the resource for private connection"
  type        = string
}

variable "subresource_names" {
  description = "subresource Namesfor the resource like adl,blob etc"
  type        = list(string)
}

# variable "private_dns_zone_ids" {
#   description = "Ids of the exiting dns group"
#   type        = list(string)
# }
variable "tags" {
  description = "Tags to apply to the MySQL server resources"
  type        = map(string)
  default     = {}
}