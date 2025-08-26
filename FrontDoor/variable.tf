variable "sku_name" {
  description = "SKU that is to be selected."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location of the Key Vault."
  type        = string
  default     = "EAST US"
}

variable "response_timeout_seconds" {
  description = "Response timeout in seconds."
  type        = number
  default     = 60
}

variable "tags" {
  description = "Map of tags."
  type        = map(string)
}

variable "frontdoor_endpoints" {
  description = "Azure CDN FrontDoor endpoints configurations."
  type = map(object({
    name                 = string
    prefix               = optional(string)
    custom_resource_name = optional(string)
    enabled              = optional(bool, true)
  }))
  default = {}
}

variable "custom_domains" {
  description = "Azure CDN FrontDoor custom domains configurations."
  type = map(object({
    name                 = string
    custom_resource_name = optional(string)
    host_name            = string
    dns_zone_id          = optional(string)
    tls = optional(object({
      certificate_type         = optional(string, "ManagedCertificate")
      minimum_tls_version      = optional(string, "TLS12")
      cdn_frontdoor_secret_id  = optional(string)
      key_vault_certificate_id = optional(string)
    }), {})
  }))
  default = {}
}

variable "origin_groups" {
  description = "List of origin groups for Front Door."
  type = map(object({
    name                                                      = string
    custom_resource_name                                      = optional(string)
    session_affinity_enabled                                  = optional(bool, true)
    restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number, 10)
    health_probe = optional(object({
      interval_in_seconds = number
      path                = string
      protocol            = string
      request_type        = string
    }))
    load_balancing = optional(object({
      additional_latency_in_milliseconds = optional(number, 50)
      sample_size                        = optional(number, 4)
      successful_samples_required        = optional(number, 3)
    }), {})
  }))
}

variable "origins" {
  description = "Azure CDN FrontDoor origins configurations."
  type = map(object({
    name                           = string
    custom_resource_name           = optional(string)
    origin_group_name              = string
    enabled                        = optional(bool, true)
    certificate_name_check_enabled = optional(bool, false)

    host_name          = string
    http_port          = optional(number, 80)
    https_port         = optional(number, 443)
    origin_host_header = optional(string)
    priority           = optional(number, 1)
    weight             = optional(number, 1000)

    private_link = optional(object({
      request_message        = optional(string)
      target_type            = optional(string)
      location               = string
      private_link_target_id = string
    }))
  }))
  default = {}
}

variable "routes" {
  description = "Azure CDN FrontDoor routes configurations."
  type = map(object({
    name                 = string
    custom_resource_name = optional(string)
    enabled              = optional(bool, true)

    endpoint_name     = string
    origin_group_name = string
    origins_names     = list(string)

    forwarding_protocol = optional(string, "HttpsOnly")
    patterns_to_match   = optional(list(string), ["/*"])
    supported_protocols = optional(list(string), ["Http", "Https"])
    cache = optional(object({
      query_string_caching_behavior = optional(string, "IgnoreQueryString")
      query_strings                 = optional(list(string))
      compression_enabled           = optional(bool, false)
      content_types_to_compress     = optional(list(string))
    }))

    custom_domains_names = optional(list(string), [])
    origin_path          = optional(string, "")
    rule_sets_names      = optional(list(string), [])

    https_redirect_enabled = optional(bool, true)
    link_to_default_domain = optional(bool, false)
  }))
  default = {}
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
  description = "Provide application/resource project code for the resource."
  type        = string
  default     = ""
}

variable "short_name" {
  description = "Provide application/resource short name for the resource."
  type        = string
  default     = ""
}
