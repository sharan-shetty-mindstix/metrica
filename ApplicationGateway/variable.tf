variable "short_name" {
  type        = string
  description = "Short name for the resource"
}
variable "public_ip_short_name" {
  type        = string
  description = "Short name for the Public IP"
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
  type        = string
  description = "Project code used in resource naming"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Key vault where certificates are stored."
}

variable "key_vault_rg_name" {
  type        = string
  description = "Name of the resource group which contains key vault."
}

variable "ssl_cert_names" {
  type        = list(string)
  description = "List of SSL certificate names in Key Vault"
}

variable "azurerm_public_ip" {
  type = object({
    allocation_method = string
    zones = list(number)
  })
  description = "Configuration for the public IP resource."
}

# sku                 = string
# zone                = string
# allocation_method   = string

variable "location" {
  type        = string
  description = "Azure region where the resource will be created"
}

variable "zones" {
  description = "A collection of availability zones to spread the Application Gateway over. This option is only supported for v2 SKUs."
  type        = list(number)
  default     = [1, 2]
}

variable "http2_enabled" {
  description = "Whether to enable http2 or not."
  type        = bool
  default     = true
}

variable "firewall_policy_id" {
  description = "ID of a Web Application Firewall Policy."
  type        = string
  default     = null
}

variable "sku_config" {
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
  description = "SKU configuration for the Application Gateway"
}
variable "autoscale_configuration" {
  description = "Map containing autoscaling parameters. Must contain at least min_capacity."
  type = object({
    min_capacity = number
    max_capacity = optional(number, 5)
  })
  default = null
}

variable "gateway_ip_configurations" {
  type = object({
    name      = string
    subnet_id = string
  })
  description = "Gateway IP configurations"
}

variable "frontend_ip_config" {
  type = object({
    name = string
  })
  description = "Frontend IP configuration"
}

variable "frontend_private_ip_configuration" {
  description = "Configuration of frontend private IP."
  type = object({
    name = string
    private_ip_address_allocation = optional(string, "Dynamic")
    private_ip_address            = optional(string)
    subnet_id = optional(string)
  })
  default = null
}

variable "frontend_ports" {
  type = map(object({
    name = string
    port = number
  }))
  description = "Frontend ports configuration"
}

variable "backend_address_pools" {
  description = "List of objects with backend pool configurations."
  type = map(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
}

variable "probes" {
  description = "List of objects with probes configurations."
  type = map(object({
    name     = string
    host     = optional(string)
    port     = optional(number, null)
    interval = number
    path     = string
    protocol = string
    timeout  = number

    unhealthy_threshold                       = number
    pick_host_name_from_backend_http_settings = optional(bool, false)
    minimum_servers                           = optional(number, 0)

    match = optional(object({
      body        = optional(string, "")
      status_code = optional(list(string), ["200-399"])
    }), {})
  }))
  default = {}
}

variable "authentication_certificates" {
  description = <<EOD
  List of objects with authentication certificates configurations.
  The path to a base-64 encoded certificate is expected in the 'data' attribute:
  data = filebase64("./file_path")
  EOD
  type = map(object({
    name = string
    data = string
  }))
  default = {}
}

variable "trusted_root_certificates" {
  description = "List of trusted root certificates. `file_path` is checked first, using `data` (base64 cert content) if null. This parameter is required if you are not using a trusted certificate authority (eg. selfsigned certificate)."
  type = map(object({
    name                = string
    data                = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default = {}
}


variable "backend_http_settings" {
  description = "List of objects including backend http settings configurations."
  type = map(object({
    name     = string
    port     = number
    protocol = string

    path       = optional(string)
    probe_name = optional(string)

    cookie_based_affinity               = string
    affinity_cookie_name                = optional(string, "ApplicationGatewayAffinity")
    request_timeout                     = optional(number, 20)
    host_name                           = optional(string)
    pick_host_name_from_backend_address = optional(bool, false)
    trusted_root_certificate_names      = optional(list(string), [])
    authentication_certificate          = optional(list(string),[])
    connection_draining_timeout_sec     = optional(list(number),[])
  }))
}

variable "ssl_certificates" {
  description = <<EOD
  List of objects with SSL certificates configurations.
  The path to a base-64 encoded certificate is expected in the 'data' attribute:
  data = filebase64("./file_path")
  EOD
  type = map(object({
    name                = string
    data                = optional(string)
    password            = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default = {}
}

variable "http_listeners" {
  type = map(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    host_name                      = optional(string)
    host_names                     = optional(list(string))
    protocol                       = optional(string, "Https")
    require_sni                    = optional(bool)
    ssl_certificate_name           = optional(string)
    firewall_policy_id             = optional(string)
    ssl_profile_name               = optional(string)
    custom_error_configuration = optional(list(object({
      status_code           = string
      custom_error_page_url = string
    })), [])
  }))
  description = "HTTP listener configurations"
}

variable "routing_rules" {
  description = "List of objects with request routing rules configurations. With AzureRM v3+ provider, `priority` attribute becomes mandatory."
  type = map(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = optional(string)
    backend_http_settings_name  = optional(string)
    url_path_map_name           = optional(string)
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name       = optional(string)
    priority                    = optional(number)
  }))
}

variable "tags" {
  description = "Map of tags."
  type        = map(string)
}