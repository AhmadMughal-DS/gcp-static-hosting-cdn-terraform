output "cdn_ip" {
  description = "Global CDN load balancer IP"
  value       = google_compute_global_address.this.address
}

output "cdn_url" {
  description = "Open once the LB has propagated (a few minutes)"
  value       = "http://${google_compute_global_address.this.address}"
}

output "bucket" {
  description = "Static site bucket"
  value       = google_storage_bucket.site.name
}
