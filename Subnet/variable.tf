## variables.tf

# Variable: naming_convention_properties - Defines the naming convention properties for resources
variable "naming_convention_properties" {
  description = "Properties for naming convention"
  type = object({
    subscription_name = string
    environment       = string
    version           = optional(string, "01")
  })
}

# Variable: project_code - The project code for the application/resource
variable "project_code" {
  description = "Provide application/resource project code for the resource"
  type        = string
}

# Variable: short_name - The short name of the application/resource
variable "short_name" {
  description = "Provide application/resource short name for the resource"
  type        = string
  default     = ""
}

# Variable: resource_group_name - The name of the resource group
variable "resource_group_name" {
  description = "The name of the resource group in which to create the subnets."
  type        = string
}

# Variable: virtual_network_name - The name of the existing virtual network
variable "virtual_network_name" {
  description = "The name of the virtual network to which to attach the subnet."
  type        = string
}

# Variable: subnets - A map of subnet configurations for the virtual network
variable "subnets" {
  description = "A map of subnet configurations."
  type = map(object({
    # Custom field for naming
    target_resource_type = string
    
    # Azure subnet resource arguments
    address_prefixes                            = list(string)
    service_endpoints                           = optional(list(string))
    private_endpoint_network_policies           = optional(string)
    private_link_service_network_policies_enabled = optional(bool)
    service_endpoint_policy_ids                 = optional(list(string))
    default_outbound_access_enabled             = optional(bool)
    delegations = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string))
      })
    })))
  }))
}