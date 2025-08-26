locals {
  type_of_resource = "agw"

  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.short_name}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"

  public_ip_name = var.public_ip_short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.public_ip_short_name}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"

  frontend_port_name = "appgw-${local.final_resource_name}-${var.location}-feport"
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg_name
}

data "azurerm_key_vault_certificate" "ssl_certificates" {
  for_each    = toset(var.ssl_cert_names)
  name        = each.value
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_user_assigned_identity" "appgw_identity" {
  name                = "${local.final_resource_name}-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_key_vault_access_policy" "appgw_policy" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = azurerm_user_assigned_identity.appgw_identity.tenant_id
  object_id    = azurerm_user_assigned_identity.appgw_identity.principal_id

  secret_permissions = ["Get"]
  certificate_permissions = ["Get"]

  depends_on = [ azurerm_user_assigned_identity.appgw_identity ]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/public_ip
resource "azurerm_public_ip" "pip" {
  name                = local.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.azurerm_public_ip.allocation_method
  zones = var.azurerm_public_ip.zones

  depends_on = [ azurerm_key_vault_access_policy.appgw_policy ]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/application_gateway
resource "azurerm_application_gateway" "application_gateway" {
  name                = local.final_resource_name
  resource_group_name = var.resource_group_name
  location            = var.location
  zones = var.zones
  firewall_policy_id = var.firewall_policy_id
  enable_http2 = var.http2_enabled

  identity {
    type         = "UserAssigned"     # Only possible value is UserAssigned.
    identity_ids = [azurerm_user_assigned_identity.appgw_identity.id]
  }

  sku {
    name     = var.sku_config.name
    tier     = var.sku_config.tier
    capacity = var.autoscale_configuration == null ? var.sku_config.capacity : null
  }

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration[*]
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_configurations.name
    subnet_id = var.gateway_ip_configurations.subnet_id
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_config.name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_private_ip_configuration[*]
    content {
      name                          = frontend_ip_configuration.value.name
      private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address_allocation
      private_ip_address            = frontend_ip_configuration.value.private_ip_address
      subnet_id                     = frontend_ip_configuration.value.subnet_id
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_ports
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.value.name
      ip_addresses = backend_address_pool.value.ip_addresses
      fqdns        = backend_address_pool.value.fqdns
    }
  }

  dynamic "probe" {
    for_each = var.probes
    content {
      name = probe.value.name

      host     = probe.value.host
      port     = probe.value.port
      interval = probe.value.interval

      path     = probe.value.path
      protocol = probe.value.protocol
      timeout  = probe.value.timeout

      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      minimum_servers                           = probe.value.minimum_servers
      match {
        body        = probe.value.match.body
        status_code = probe.value.match.status_code
      }
    }
  }

  dynamic "authentication_certificate" {
    for_each = var.authentication_certificates
    content {
      name = authentication_certificate.value.name
      data = filebase64(authentication_certificate.value.data)
    }
  }

    dynamic "trusted_root_certificate" {
      for_each = var.trusted_root_certificates
      iterator = root_cert
      content {
        name                = root_cert.value.name
        data                = root_cert.value.data != null && root_cert.value.data != "" ? filebase64(root_cert.value.data) : null
        key_vault_secret_id = root_cert.value.data != null && root_cert.value.data != "" ? null : data.azurerm_key_vault_certificate.ssl_certificates[root_cert.value.name].secret_id
      }
    }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    iterator = back_http_set
    content {
      name     = back_http_set.value.name
      port     = back_http_set.value.port
      protocol = back_http_set.value.protocol

      path       = back_http_set.value.path
      probe_name = back_http_set.value.probe_name

      cookie_based_affinity               = back_http_set.value.cookie_based_affinity
      affinity_cookie_name                = back_http_set.value.affinity_cookie_name
      request_timeout                     = back_http_set.value.request_timeout
      host_name                           = back_http_set.value.host_name
      pick_host_name_from_backend_address = back_http_set.value.pick_host_name_from_backend_address
      trusted_root_certificate_names      = back_http_set.value.trusted_root_certificate_names

      dynamic "authentication_certificate" {
        for_each = back_http_set.value.authentication_certificate[*]
        content {
          name = authentication_certificate.value
        }
      }

      dynamic "connection_draining" {
        for_each = back_http_set.value.connection_draining_timeout_sec[*]
        content {
          enabled           = true
          drain_timeout_sec = connection_draining.value
        }
      }
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    iterator = ssl_crt
    content {
      name                = ssl_crt.value.name
      data                = ssl_crt.value.data
      password            = ssl_crt.value.password
      key_vault_secret_id = ssl_crt.value.data != null && ssl_crt.value.data != "" ? null : join("/", slice(split("/", data.azurerm_key_vault_certificate.ssl_certificates[ssl_crt.value.name].secret_id), 0, 5))
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    iterator = http_listen
    content {
      name = http_listen.value.name
      frontend_ip_configuration_name = http_listen.value.frontend_ip_configuration_name
      
      frontend_port_name   = http_listen.value.frontend_port_name
      host_name            = http_listen.value.host_name
      host_names           = http_listen.value.host_names
      protocol             = http_listen.value.protocol
      require_sni          = http_listen.value.require_sni
      ssl_certificate_name = http_listen.value.ssl_certificate_name
      ssl_profile_name     = http_listen.value.ssl_profile_name
      firewall_policy_id   = http_listen.value.firewall_policy_id

      dynamic "custom_error_configuration" {
        for_each = http_listen.value.custom_error_configuration
        iterator = err_conf
        content {
          status_code           = err_conf.value.status_code
          custom_error_page_url = err_conf.value.custom_error_page_url
        }
      }
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.routing_rules
    iterator = routing
    content {
      name      = routing.value.name
      rule_type = routing.value.rule_type

      http_listener_name          = routing.value.http_listener_name
      backend_address_pool_name   = routing.value.backend_address_pool_name
      backend_http_settings_name  = routing.value.backend_http_settings_name
      url_path_map_name           = routing.value.url_path_map_name
      redirect_configuration_name = routing.value.redirect_configuration_name
      rewrite_rule_set_name       = routing.value.rewrite_rule_set_name
      priority                    = routing.value.priority
    }
  }
  tags = var.tags

  depends_on = [ azurerm_public_ip.pip ]
}