locals {
  name = var.project_name
}

resource "random_id" "suffix" {
  byte_length = 3
}

############################
# Storage bucket (website)
############################
resource "google_storage_bucket" "site" {
  name                        = "${var.project_id}-${local.name}-site-${random_id.suffix.hex}"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_iam_member" "public" {
  bucket = google_storage_bucket.site.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_object" "index" {
  name         = "index.html"
  bucket       = google_storage_bucket.site.name
  content_type = "text/html"
  content      = "<!doctype html><html><body style=\"font-family:sans-serif;text-align:center;padding-top:60px\"><h1>Static site on Cloud Storage + Cloud CDN</h1><p>By Muhammad Ahmad</p></body></html>"
}

resource "google_storage_bucket_object" "notfound" {
  name         = "404.html"
  bucket       = google_storage_bucket.site.name
  content_type = "text/html"
  content      = "<!doctype html><html><body style=\"font-family:sans-serif;text-align:center;padding-top:60px\"><h1>404 - Not Found</h1></body></html>"
}

############################
# Backend bucket + CDN + HTTP LB
############################
resource "google_compute_backend_bucket" "this" {
  name        = "${local.name}-backend"
  bucket_name = google_storage_bucket.site.name
  enable_cdn  = true
}

resource "google_compute_url_map" "this" {
  name            = "${local.name}-urlmap"
  default_service = google_compute_backend_bucket.this.id
}

resource "google_compute_target_http_proxy" "this" {
  name    = "${local.name}-proxy"
  url_map = google_compute_url_map.this.id
}

resource "google_compute_global_address" "this" {
  name = "${local.name}-cdn-ip"
}

resource "google_compute_global_forwarding_rule" "this" {
  name                  = "${local.name}-forwarding-rule"
  target                = google_compute_target_http_proxy.this.id
  port_range            = "80"
  ip_address            = google_compute_global_address.this.address
  load_balancing_scheme = "EXTERNAL"
}
