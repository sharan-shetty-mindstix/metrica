locals {
  type_of_resource = "afd"

  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.short_name}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/cdn_frontdoor_profile
resource "azurerm_cdn_frontdoor_profile" "frontdoor_profile" {
  name                     = local.final_resource_name
  resource_group_name      = var.resource_group_name
  sku_name                 = var.sku_name
  response_timeout_seconds = var.response_timeout_seconds
  tags                     = var.tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/cdn_frontdoor_endpoint
resource "azurerm_cdn_frontdoor_endpoint" "frontdoor_endpoint" {
  for_each = { for endpoint in var.frontdoor_endpoints : endpoint.name => endpoint }

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile.id
  enabled                  = each.value.enabled
  tags                     = var.tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/cdn_frontdoor_custom_domain
resource "azurerm_cdn_frontdoor_custom_domain" "custom_domain" {
  for_each = { for domain in var.custom_domains : domain.name => domain }

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile.id
  dns_zone_id              = each.value.dns_zone_id
  host_name                = each.value.host_name

  dynamic "tls" {
    for_each = each.value.tls == null ? [] : ["enabled"]
    content {
      certificate_type    = each.value.tls.certificate_type
      minimum_tls_version = each.value.tls.minimum_tls_version
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/cdn_frontdoor_origin_group
resource "azurerm_cdn_frontdoor_origin_group" "origin_group" {
  for_each = { for group in var.origin_groups : group.name => group }

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile.id

  session_affinity_enabled = each.value.session_affinity_enabled

  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = each.value.restore_traffic_time_to_healed_or_new_endpoint_in_minutes

  dynamic "health_probe" {
    for_each = each.value.health_probe == null ? [] : ["enabled"]
    content {
      interval_in_seconds = each.value.health_probe.interval_in_seconds
      path                = each.value.health_probe.path
      protocol            = each.value.health_probe.protocol
      request_type        = each.value.health_probe.request_type
    }
  }

  load_balancing {
    additional_latency_in_milliseconds = each.value.load_balancing.additional_latency_in_milliseconds
    sample_size                        = each.value.load_balancing.sample_size
    successful_samples_required        = each.value.load_balancing.successful_samples_required
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/cdn_frontdoor_origin
resource "azurerm_cdn_frontdoor_origin" "origin" {
  for_each = { for origin in var.origins : origin.name => origin }

  name                          = each.value.name
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group[each.value.origin_group_name].id

  enabled                        = each.value.enabled
  certificate_name_check_enabled = each.value.certificate_name_check_enabled
  host_name                      = each.value.host_name
  http_port                      = each.value.http_port
  https_port                     = each.value.https_port
  origin_host_header             = each.value.origin_host_header
  priority                       = each.value.priority
  weight                         = each.value.weight

  dynamic "private_link" {
    for_each = each.value.private_link == null ? [] : ["enabled"]
    content {
      request_message        = each.value.private_link.request_message
      target_type            = each.value.private_link.target_type
      location               = each.value.private_link.location
      private_link_target_id = each.value.private_link.private_link_target_id
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/cdn_frontdoor_route
resource "azurerm_cdn_frontdoor_route" "route" {
  for_each = { for route in var.routes : route.name => route }

  name    = each.value.name
  enabled = each.value.enabled

  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.frontdoor_endpoint[each.value.endpoint_name].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group[each.value.origin_group_name].id

  cdn_frontdoor_origin_ids = flatten([
    for origin in each.value.origins_names :
    azurerm_cdn_frontdoor_origin.origin[origin].id
  ])

  forwarding_protocol = each.value.forwarding_protocol
  patterns_to_match   = each.value.patterns_to_match
  supported_protocols = each.value.supported_protocols

  dynamic "cache" {
    for_each = each.value.cache == null ? [] : ["enabled"]
    content {
      query_string_caching_behavior = each.value.cache.query_string_caching_behavior
      query_strings                 = each.value.cache.query_strings
      compression_enabled           = each.value.cache.compression_enabled
      content_types_to_compress     = each.value.cache.content_types_to_compress
    }
  }

  cdn_frontdoor_custom_domain_ids = flatten([
    for domain in each.value.custom_domains_names :
    azurerm_cdn_frontdoor_custom_domain.custom_domain[domain].id
  ])

  cdn_frontdoor_origin_path  = each.value.origin_path
  cdn_frontdoor_rule_set_ids = each.value.rule_sets_names

  https_redirect_enabled = each.value.https_redirect_enabled
  link_to_default_domain = each.value.link_to_default_domain
}


