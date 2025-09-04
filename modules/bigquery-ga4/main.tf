# BigQuery Dataset for GA4 Data
resource "google_bigquery_dataset" "ga4_dataset" {
  dataset_id    = var.ga4_dataset_id
  friendly_name = var.ga4_dataset_friendly_name
  description   = var.ga4_dataset_description
  location      = var.gcp_region
  project       = var.gcp_project_id

  # Dataset labels
  labels = var.dataset_labels

  # Access controls
  access {
    role          = "OWNER"
    special_group = "projectOwners"
  }

  access {
    role          = "READER"
    special_group = "projectReaders"
  }

  # Default table expiration (30 days for raw GA4 data)
  default_table_expiration_ms = var.default_table_expiration_ms

  # Default partition expiration (90 days for partitioned tables)
  default_partition_expiration_ms = var.default_partition_expiration_ms

  # Delete protection
  delete_contents_on_destroy = var.delete_contents_on_destroy
}

# BigQuery Table for GA4 Events (if GA4 export is not enabled)
resource "google_bigquery_table" "ga4_events" {
  count          = var.create_ga4_events_table ? 1 : 0
  dataset_id     = google_bigquery_dataset.ga4_dataset.dataset_id
  table_id       = var.ga4_events_table_id
  project        = var.gcp_project_id
  description    = "GA4 events data table"
  deletion_protection = var.table_deletion_protection

  # Schema for GA4 events (basic structure)
  schema = jsonencode([
    {
      name = "event_date"
      type = "DATE"
      mode = "REQUIRED"
      description = "Date when the event occurred"
    },
    {
      name = "event_timestamp"
      type = "TIMESTAMP"
      mode = "REQUIRED"
      description = "Timestamp when the event occurred"
    },
    {
      name = "event_name"
      type = "STRING"
      mode = "REQUIRED"
      description = "Name of the event"
    },
    {
      name = "user_pseudo_id"
      type = "STRING"
      mode = "REQUIRED"
      description = "Pseudo ID of the user"
    },
    {
      name = "user_id"
      type = "STRING"
      mode = "NULLABLE"
      description = "User ID if available"
    },
    {
      name = "session_id"
      type = "STRING"
      mode = "NULLABLE"
      description = "Session ID"
    },
    {
      name = "device_category"
      type = "STRING"
      mode = "NULLABLE"
      description = "Device category"
    },
    {
      name = "operating_system"
      type = "STRING"
      mode = "NULLABLE"
      description = "Operating system"
    },
    {
      name = "browser"
      type = "STRING"
      mode = "NULLABLE"
      description = "Browser name"
    },
    {
      name = "country"
      type = "STRING"
      mode = "NULLABLE"
      description = "Country"
    },
    {
      name = "city"
      type = "STRING"
      mode = "NULLABLE"
      description = "City"
    },
    {
      name = "page_title"
      type = "STRING"
      mode = "NULLABLE"
      description = "Page title"
    },
    {
      name = "page_location"
      type = "STRING"
      mode = "NULLABLE"
      description = "Page URL"
    },
    {
      name = "event_parameters"
      type = "JSON"
      mode = "NULLABLE"
      description = "Event parameters as JSON"
    },
    {
      name = "user_properties"
      type = "JSON"
      mode = "NULLABLE"
      description = "User properties as JSON"
    }
  ])

  # Time partitioning
  time_partitioning {
    type                     = "DAY"
    field                    = "event_date"
    require_partition_filter = false
    expiration_ms            = var.partition_expiration_ms
  }

  # Clustering for better query performance
  clustering = ["event_name", "device_category", "country"]

  labels = var.table_labels
}

# BigQuery Table for GA4 Users
resource "google_bigquery_table" "ga4_users" {
  count          = var.create_ga4_users_table ? 1 : 0
  dataset_id     = google_bigquery_dataset.ga4_dataset.dataset_id
  table_id       = var.ga4_users_table_id
  project        = var.gcp_project_id
  description    = "GA4 users dimension table"
  deletion_protection = var.table_deletion_protection

  schema = jsonencode([
    {
      name = "user_pseudo_id"
      type = "STRING"
      mode = "REQUIRED"
      description = "Pseudo ID of the user"
    },
    {
      name = "user_id"
      type = "STRING"
      mode = "NULLABLE"
      description = "User ID if available"
    },
    {
      name = "first_seen_date"
      type = "DATE"
      mode = "REQUIRED"
      description = "Date when user was first seen"
    },
    {
      name = "last_seen_date"
      type = "DATE"
      mode = "REQUIRED"
      description = "Date when user was last seen"
    },
    {
      name = "total_events"
      type = "INTEGER"
      mode = "REQUIRED"
      description = "Total number of events"
    },
    {
      name = "total_sessions"
      type = "INTEGER"
      mode = "REQUIRED"
      description = "Total number of sessions"
    },
    {
      name = "device_category"
      type = "STRING"
      mode = "NULLABLE"
      description = "Primary device category"
    },
    {
      name = "country"
      type = "STRING"
      mode = "NULLABLE"
      description = "Primary country"
    },
    {
      name = "user_properties"
      type = "JSON"
      mode = "NULLABLE"
      description = "User properties as JSON"
    }
  ])

  labels = var.table_labels
}

# BigQuery Table for GA4 Sessions
resource "google_bigquery_table" "ga4_sessions" {
  count          = var.create_ga4_sessions_table ? 1 : 0
  dataset_id     = google_bigquery_dataset.ga4_dataset.dataset_id
  table_id       = var.ga4_sessions_table_id
  project        = var.gcp_project_id
  description    = "GA4 sessions dimension table"
  deletion_protection = var.table_deletion_protection

  schema = jsonencode([
    {
      name = "session_id"
      type = "STRING"
      mode = "REQUIRED"
      description = "Session ID"
    },
    {
      name = "user_pseudo_id"
      type = "STRING"
      mode = "REQUIRED"
      description = "Pseudo ID of the user"
    },
    {
      name = "session_start_time"
      type = "TIMESTAMP"
      mode = "REQUIRED"
      description = "Session start time"
    },
    {
      name = "session_end_time"
      type = "TIMESTAMP"
      mode = "NULLABLE"
      description = "Session end time"
    },
    {
      name = "session_duration_seconds"
      type = "INTEGER"
      mode = "NULLABLE"
      description = "Session duration in seconds"
    },
    {
      name = "page_views"
      type = "INTEGER"
      mode = "REQUIRED"
      description = "Number of page views"
    },
    {
      name = "events"
      type = "INTEGER"
      mode = "REQUIRED"
      description = "Number of events"
    },
    {
      name = "bounces"
      type = "INTEGER"
      mode = "REQUIRED"
      description = "Number of bounces"
    },
    {
      name = "device_category"
      type = "STRING"
      mode = "NULLABLE"
      description = "Device category"
    },
    {
      name = "operating_system"
      type = "STRING"
      mode = "NULLABLE"
      description = "Operating system"
    },
    {
      name = "browser"
      type = "STRING"
      mode = "NULLABLE"
      description = "Browser name"
    },
    {
      name = "country"
      type = "STRING"
      mode = "NULLABLE"
      description = "Country"
    },
    {
      name = "city"
      type = "STRING"
      mode = "NULLABLE"
      description = "City"
    },
    {
      name = "traffic_source"
      type = "STRING"
      mode = "NULLABLE"
      description = "Traffic source"
    },
    {
      name = "medium"
      type = "STRING"
      mode = "NULLABLE"
      description = "Medium"
    },
    {
      name = "source"
      type = "STRING"
      mode = "NULLABLE"
      description = "Source"
    },
    {
      name = "campaign"
      type = "STRING"
      mode = "NULLABLE"
      description = "Campaign name"
    }
  ])

  # Time partitioning
  time_partitioning {
    type                     = "DAY"
    field                    = "session_start_time"
    require_partition_filter = false
    expiration_ms            = var.partition_expiration_ms
  }

  # Clustering for better query performance
  clustering = ["user_pseudo_id", "device_category", "country"]

  labels = var.table_labels
}

# IAM binding for Azure Data Factory service account
resource "google_bigquery_dataset_iam_binding" "adf_access" {
  count      = var.enable_adf_access ? 1 : 0
  dataset_id = google_bigquery_dataset.ga4_dataset.dataset_id
  project    = var.gcp_project_id
  role       = "roles/bigquery.dataViewer"

  members = [
    "serviceAccount:${var.adf_service_account_email}",
  ]
}

# IAM binding for BigQuery Job User role
# Note: roles/bigquery.jobUser is not supported at dataset level
# Job user permissions are granted at project level in the GCP service account module

