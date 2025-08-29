output "email" {
  description = "Email of the service account"
  value       = google_service_account.service_account.email
  sensitive   = true
}

output "name" {
  description = "Name of the service account"
  value       = google_service_account.service_account.name
}

output "private_key" {
  description = "Private key of the service account"
  value       = base64decode(google_service_account_key.service_account_key.private_key)
  sensitive   = true
}
