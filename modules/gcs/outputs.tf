output "buckets" {
  description = "Map of bucket names and their properties"
  value = {
    for name, bucket in google_storage_bucket.buckets : name => {
      name     = bucket.name
      id       = bucket.id
      location = bucket.location
      url      = bucket.url
    }
  }
}

output "bucket_names" {
  description = "Map of bucket names"
  value = {
    for name, bucket in google_storage_bucket.buckets : name => bucket.name
  }
}
