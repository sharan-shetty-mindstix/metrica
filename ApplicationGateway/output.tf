output "application_gateway_name" {
  description = "The name of the Application Gateway"
  value       = azurerm_application_gateway.application_gateway.name
}

output "public_ip_address" {
  description = "The public IP address of the Application Gateway"
  value       = azurerm_public_ip.pip.ip_address
}
