locals {
  labels = { project = var.name_prefix, environment = var.environment, managed_by = "terraform", owner = "muhammad-ahmad" }
}

resource "random_id" "suffix" {
  byte_length = 3
}

resource "google_storage_bucket" "site" {
  name                        = "${var.project_id}-${var.name_prefix}-site-${random_id.suffix.hex}"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = local.labels

  versioning {
    enabled = true
  }
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

resource "google_compute_backend_bucket" "this" {
  name        = "${var.name_prefix}-backend"
  bucket_name = google_storage_bucket.site.name
  enable_cdn  = true

  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    client_ttl        = 3600
    default_ttl       = 3600
    max_ttl           = 86400
    negative_caching  = true
    serve_while_stale = 86400
  }
}

resource "google_compute_url_map" "this" {
  name            = "${var.name_prefix}-urlmap"
  default_service = google_compute_backend_bucket.this.id
}

resource "google_compute_target_http_proxy" "this" {
  name    = "${var.name_prefix}-proxy"
  url_map = google_compute_url_map.this.id
}

resource "google_compute_global_address" "this" {
  name = "${var.name_prefix}-cdn-ip"
}

resource "google_compute_global_forwarding_rule" "this" {
  name                  = "${var.name_prefix}-forwarding-rule"
  target                = google_compute_target_http_proxy.this.id
  port_range            = "80"
  ip_address            = google_compute_global_address.this.address
  load_balancing_scheme = "EXTERNAL"
}
