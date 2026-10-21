output "cdn_ip" {
  value = google_compute_global_address.this.address
}
output "bucket" {
  value = google_storage_bucket.site.name
}
