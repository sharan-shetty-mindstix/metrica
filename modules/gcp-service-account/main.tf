# GCP Service Account for Azure Data Factory
resource "google_service_account" "adf_service_account" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  description  = var.service_account_description
  project      = var.gcp_project_id
}

# Service Account Key (for Azure Data Factory authentication)
resource "google_service_account_key" "adf_service_account_key" {
  count              = var.create_service_account_key ? 1 : 0
  service_account_id = google_service_account.adf_service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

# IAM binding for BigQuery Data Viewer role
resource "google_project_iam_member" "bigquery_data_viewer" {
  count   = var.enable_bigquery_access ? 1 : 0
  project = var.gcp_project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${google_service_account.adf_service_account.email}"
}

# IAM binding for BigQuery Job User role
resource "google_project_iam_member" "bigquery_job_user" {
  count   = var.enable_bigquery_access ? 1 : 0
  project = var.gcp_project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.adf_service_account.email}"
}

# IAM binding for BigQuery Data Editor role (if needed for data manipulation)
resource "google_project_iam_member" "bigquery_data_editor" {
  count   = var.enable_bigquery_data_editor ? 1 : 0
  project = var.gcp_project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.adf_service_account.email}"
}

# IAM binding for Storage Object Viewer role (if using GCS)
resource "google_project_iam_member" "storage_object_viewer" {
  count   = var.enable_storage_access ? 1 : 0
  project = var.gcp_project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.adf_service_account.email}"
}

# Note: GA4 Analytics roles are not available at project level
# GA4 access is managed through the GA4 property itself
# The service account will need to be granted access directly in GA4 Admin

# Workload Identity Pool (for more secure authentication with Azure)
resource "google_iam_workload_identity_pool" "azure_pool" {
  count                     = var.enable_workload_identity ? 1 : 0
  workload_identity_pool_id = var.workload_identity_pool_id
  display_name              = var.workload_identity_pool_display_name
  description               = var.workload_identity_pool_description
  project                   = var.gcp_project_id
}

# Workload Identity Provider for Azure
resource "google_iam_workload_identity_pool_provider" "azure_provider" {
  count                              = var.enable_workload_identity ? 1 : 0
  workload_identity_pool_id          = google_iam_workload_identity_pool.azure_pool[0].workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_provider_id
  display_name                       = var.workload_identity_provider_display_name
  description                        = var.workload_identity_provider_description
  project                            = var.gcp_project_id

  attribute_mapping = {
    "google.subject" = "assertion.sub"
    "attribute.tenant_id" = "assertion.tid"
    "attribute.client_id" = "assertion.aud"
  }

  oidc {
    issuer_uri = "https://sts.windows.net/${var.azure_tenant_id}/"
  }
}

# Allow Azure Data Factory to impersonate the service account
resource "google_service_account_iam_binding" "workload_identity_binding" {
  count              = var.enable_workload_identity ? 1 : 0
  service_account_id = google_service_account.adf_service_account.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.azure_pool[0].name}/attribute.tenant_id/${var.azure_tenant_id}",
  ]
}

