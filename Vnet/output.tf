# Output: subnet_ids - Outputs a map of subnet IDs
output "subnet_ids" {
  # The value will be a map, where the key is the subnet name (or key from the subnets map)
  # and the value is the corresponding subnet ID from the azurerm_subnet resource.
  value = {
    for k, v in azurerm_subnet.subnets : k => v.id # Key is the subnet's key, value is the subnet's ID
  }
}
