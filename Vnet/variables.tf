# Variable: naming_convention_properties - Defines the naming convention properties for resources
variable "naming_convention_properties" {
  description = "Properties for naming convention"

  # Type is an object with required subscription_name, environment, and an optional version
  type = object({
    subscription_name = string                 # The subscription name
    environment       = string                 # The environment (e.g., 'dev', 'prod')
    version           = optional(string, "01") # Optional version, defaulting to "01"
  })
}

# Variable: project_code - The project code for the application/resource
variable "project_code" {
  description = "Provide application/resource project code for the resource"

  type    = string
  default = "" # Default to an empty string if not provided
}

# Variable: short_name - The short name of the application/resource
variable "short_name" {
  description = "Provide application/resource short name for the resource"

  type    = string
  default = "" # Default to an empty string if not provided
}

# Variable: tags - A map of tags to apply to resources for identification or categorization
variable "tags" {
  description = "Map of tags."

  type = map(string) # A map where keys and values are strings
}

# Variable: address_space - The address space (CIDR blocks) for the virtual network
variable "address_space" {
  description = "The address space of the virtual network."

  type = list(string) # A list of CIDR blocks as strings
}

# Variable: location - The location (region) of the resource group
variable "location" {
  description = "The location of the resource group."

  type = string # The region name (e.g., "East US")
}

# Variable: resource_group_name - The name of the resource group
variable "resource_group_name" {
  description = "The name of the resource group."

  type = string # The resource group's name
}

# Variable: subnets - A map of subnet configurations for the virtual network
variable "subnets" {
  description = "A map of subnet configurations."

  # A map where each key represents a subnet and each value is an object with detailed subnet configuration
  type = map(object({
    target_resource_type = string                 # The resource type for this subnet (e.g., "VirtualMachine")
    address_prefixes     = list(string)           # A list of address prefixes (CIDR blocks) for this subnet
    service_endpoints    = optional(list(string)) # Optional list of service endpoints for the subnet
    delegations = optional(list(object({
      name = string # The delegation name

      service_delegation = object({
        name    = string       # The name of the service delegation
        actions = list(string) # List of actions allowed by the service delegation
      })
    }))) # Optional list of delegations if any
  }))
}
