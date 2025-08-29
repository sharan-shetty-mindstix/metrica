resource "google_storage_bucket" "buckets" {
  for_each = var.buckets
  
  name          = each.value.name
  location      = each.value.location
  force_destroy = lookup(each.value, "force_destroy", false)
  
  # Security settings
  uniform_bucket_level_access = true
  
  # Versioning
  versioning {
    enabled = lookup(each.value, "versioning_enabled", true)
  }
  
  # Lifecycle rules
  dynamic "lifecycle_rule" {
    for_each = lookup(each.value, "lifecycle_rules", [])
    content {
      condition {
        age = lifecycle_rule.value.age
      }
      action {
        type = lifecycle_rule.value.action_type
      }
    }
  }
  
  # Labels
  labels = merge(var.common_labels, lookup(each.value, "labels", {}))
}
