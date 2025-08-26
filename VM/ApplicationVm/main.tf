# Locals
locals {
  # Define the type of resource as 'vm' (virtual machine)
  type_of_resource = "vm"

  # Define the final name for the virtual machine resource based on the naming convention
  final_resource_name = var.short_name != "" ? "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.short_name}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}" : "${var.naming_convention_properties.subscription_name}-${var.project_code}-${local.type_of_resource}-${var.naming_convention_properties.environment}${var.naming_convention_properties.version}"

  # Generate the admin password for the VM (using random_password resource)
  admin_password_vm = random_password.admin_password.result

  # Generate the expiration date for the secret in Key Vault, if applicable
  generated_secret_expiration_date_utc = var.generated_secrets_key_vault_secret_config != null ? formatdate("YYYY-MM-DD'T'hh:mm:ssZ", timeadd(time_static.secret_creation_time.rfc3339, "${var.generated_secrets_key_vault_secret_config.expiration_date_length_in_days * 24}h")) : null
}

# Time resource to track the secret creation time (depends on random password creation)
resource "time_static" "secret_creation_time" {
  depends_on = [random_password.admin_password]
}

# Data source to fetch an existing subnet by name, virtual network name, and resource group
data "azurerm_subnet" "existing_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}

# Resource to generate a random password for the VM admin user
resource "random_password" "admin_password" {
  length           = 22
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  override_special = "!#$%&()*+,-./:;<=>?@[]^_{|}~"
  special          = true
}

# Resource to store the VM admin password as a secret in Azure Key Vault
resource "azurerm_key_vault_secret" "vm_password" {
  name            = var.generated_secrets_key_vault_secret_config.name
  value           = local.admin_password_vm
  key_vault_id    = var.generated_secrets_key_vault_secret_config.key_vault_resource_id
  expiration_date = local.generated_secret_expiration_date_utc

  depends_on = [random_password.admin_password]    # Ensure the secret is created after the admin password generation
}

# https://github.com/Azure/terraform-azurerm-avm-res-compute-virtualmachine/tree/main
# Virtual machine module to create the VM using the Azure module
module "virtual_machine2" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.17.0"

  # VM properties
  name                = local.final_resource_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_size            = var.sku_size

  admin_username      = var.admin_username
  disable_password_authentication = var.disable_password_authentication
  encryption_at_host_enabled = var.encryption_at_host_enabled
  generate_admin_password_or_ssh_key = var.generate_admin_password_or_ssh_key
  zone                = var.zone
  admin_password      = local.admin_password_vm

  managed_identities = var.managed_identities != null ? {    # Managed identities (system-assigned or user-assigned)
    system_assigned            = var.managed_identities.system_assigned
    user_assigned_resource_ids = var.managed_identities.user_assigned_identity_ids
  } : null

  network_interfaces = {    # Network interfaces configuration
    for nic in var.nics : nic.name => {
      name = nic.name
      ip_configurations = {
        for ip_config in nic.ip_configurations : ip_config.name => {
          name                          = ip_config.name
          private_ip_subnet_resource_id = data.azurerm_subnet.existing_subnet.id
          private_ip_address            = ip_config.private_ip_address
        }
      }
    }
  }

  os_disk                = var.os_disk    # OS disk and image reference
  source_image_reference = var.source_image_reference
  tags                   = var.vm_tags
  user_data              = var.user_data
  enable_telemetry      = var.enable_telemetry

  depends_on = [azurerm_key_vault_secret.vm_password]    # Ensure VM creation before storing the Key Vault secret
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/virtual_machine_extension
# Virtual Machine Extensions resource to configure VM extensions (e.g., for monitoring or agents)
resource "azurerm_virtual_machine_extension" "vm_extensions" {
  for_each = var.extensions != null ? var.extensions : {}

  # Extension properties
  name                       = each.value.name
  virtual_machine_id         = module.virtual_machine2.resource_id
  publisher                  = each.value.publisher
  type                       = each.value.type
  type_handler_version       = each.value.type_handler_version
  settings                   = each.value.settings
  protected_settings         = lookup(each.value, "protected_settings", null)
  provision_after_extensions = lookup(each.value, "provision_after_extensions", [])
  tags                       = lookup(each.value, "tags", null)

  depends_on = [module.virtual_machine2]    # Ensure VM creation before applying extensions
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/network_security_group
# Network Security Group (NSG) resource to manage security rules for the VM
resource "azurerm_network_security_group" "nsg" {
  name                = "${local.final_resource_name}-nsg01"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Dynamic block to create security rules from the input variables
  dynamic "security_rule" {
    for_each = var.nsg_config.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags       = var.vm_tags   # NSG tags

  depends_on = [module.virtual_machine2]    # Ensure the VM is created before creating the NSG
}

# https://registry.terraform.io/providers/hashicorp/azurerm/4.10.0/docs/resources/network_interface_security_group_association
# Network Interface Security Group (NSG) association to link NSG with VM NIC
resource "azurerm_network_interface_security_group_association" "nsg_nic_association" {
  for_each                  = module.virtual_machine2.network_interfaces
  network_interface_id      = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id

  # Ensure NSG and VM creation happens before associating them
  depends_on                = [module.virtual_machine2, azurerm_network_security_group.nsg]
}
