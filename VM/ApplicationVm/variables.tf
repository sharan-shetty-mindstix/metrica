# Variables Definition for Virtual Machine Module

# Naming Variables
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
  default     = "" # Default is an empty string, so it's optional
}

variable "short_name" {
  description = "Provide application/resource short name for the resource"
  type        = string
  default     = "" # Default is an empty string, so it's optional
}

# Core VM Configuration
variable "resource_group_name" {
  description = "Name of the resource group where the VM will be created."
  type        = string
}

variable "location" {
  description = "Azure location for the VM."
  type        = string
}

variable "os_type" {
  description = "Operating system type for the VM (e.g., Linux or Windows)."
  type        = string
}

variable "sku_size" {
  description = "The size (SKU) of the virtual machine."
  type        = string
}

# Administrative Configuration
variable "admin_username" {
  description = "Administrator username for the VM."
  type        = string
}

variable "disable_password_authentication" {
  description = "Flag to disable password authentication for the VM."
  type        = bool
}

variable "encryption_at_host_enabled" {
  description = "Flag to enable encryption at host for the VM."
  type        = bool
}

variable "generate_admin_password_or_ssh_key" {
  description = "Flag to generate an admin password or SSH key for the VM."
  type        = bool
}

variable "zone" {
  description = "Availability zone for the VM."
  type        = number
}

# Network Interfaces Configuration
variable "nics" {
  description = "List of network interface configurations for the VM, including multiple IP configurations."
  type = list(object({
    name = string
    ip_configurations = list(object({
      name               = string
      private_ip_address = optional(string) # Private IP address can be optional
    }))
  }))
}

# OS Disk Configuration
variable "os_disk" {
  description = "Configuration for the OS disk of the VM."
  type = object({
    caching              = string
    storage_account_type = string
    disk_size_gb = optional(number, 30)
  })
}

# Source Image Reference
variable "source_image_reference" {
  description = "Source image reference for the VM."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

# Tags for the VM
variable "vm_tags" {
  description = "Tags to apply to the VM."
  type        = map(string)
}

# Network-related Variables
variable "vnet_rg_name" {
  description = "Name of the existing resource group where the VNet will be created."
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet."
  type        = string
}

variable "vnet_name" {
  description = "Name of the VNet."
  type        = string
}

# Key Vault Configuration for Secrets
variable "generated_secrets_key_vault_secret_config" {
  description = "Configuration for the private DNS zone and its virtual network link"
  type = object({
    name                           = string
    key_vault_resource_id          = string
    expiration_date_length_in_days = number # Number of days until the secret expires
  })
}

# VM Extensions Configuration
variable "extensions" {
  description = "Optional configuration for VM extensions"
  type = map(object({
    name                        = string
    publisher                   = string
    type                        = string
    type_handler_version        = string
    auto_upgrade_minor_version  = optional(bool) # Optional flag for auto upgrade
    automatic_upgrade_enabled   = optional(bool) # Optional flag for automatic upgrades
    failure_suppression_enabled = optional(bool, false) # Default to false
    settings                    = optional(string) # Optional settings for the extension
    protected_settings          = optional(string) # Optional protected settings for the extension
    provision_after_extensions  = optional(list(string), []) # List of extensions to provision after
    tags                        = optional(map(string), null) # Optional tags for the extension
    protected_settings_from_key_vault = optional(object({
      secret_url      = string
      source_vault_id = string
    })) # Optional protected settings from Key Vault
  }))
  default = {} # Default is an empty map, so no extensions are applied unless specified
}

# Public IP Configuration (Optional)
variable "public_ip" {
  description = "Configuration for the public IP."
  type = object({
    allocation_method = string # e.g., Static or Dynamic
  })
  default = null # Default is null, so it's optional and can be omitted
}

# Network Security Group Configuration
variable "nsg_config" {
  description = "Configuration for the Network Security Group and its rules."
  type = object({
    security_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
    tags = optional(map(string), {}) # Optional tags for the NSG, defaults to an empty map
  })
}

# Managed Identities Configuration
variable "managed_identities" {
  description = "Configuration for managed identities (system-assigned and user-assigned)."
  type = object({
    system_assigned            = bool
    user_assigned_identity_ids = optional(list(string), []) # Optional list of user-assigned identities
  })
  default = {
    system_assigned            = false
    user_assigned_identity_ids = [] # Defaults to an empty list
  }
}

# User Data (Optional)
variable "user_data" {
  description = "(Optional) The Base64-Encoded User Data which should be used for this Virtual Machine."
  type        = string
  default     = null # Default is null, indicating this is optional
}

# Telemetry Flag (Optional)
variable "enable_telemetry" {
  description = "(Optional) Flag to enable or disable telemetry."
  type        = bool
  default     = true # Default is true, so telemetry is enabled by default
}
