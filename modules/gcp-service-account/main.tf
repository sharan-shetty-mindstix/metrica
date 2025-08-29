resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = var.display_name
  description  = var.description
  project      = var.project_id
}

resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

# Grant storage permissions to the service account
resource "google_project_iam_member" "storage_permissions" {
  for_each = toset(var.bucket_permissions)
  
  project = var.project_id
  role    = "roles/storage.${each.value}"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

# Grant specific bucket permissions
resource "google_storage_bucket_iam_member" "bucket_permissions" {
  for_each = toset(var.buckets)
  
  bucket = each.value
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.service_account.email}"
}
