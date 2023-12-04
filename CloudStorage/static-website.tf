resource "google_storage_bucket" "static-site" {
  name          = "static.piasecki.it"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["http://static.piasecki.it"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_object" "indexpage" {
  name         = "index.html"
  source       = "objects/index.html"
  content_type = "text/html"
  bucket       = google_storage_bucket.static-site.id
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.static-site.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_compute_global_address" "default" {
  name = "example-ip"
}

resource "google_compute_backend_bucket" "static-site" {
  name        = "cats"
  description = "Contains cat image"
  bucket_name = google_storage_bucket.static-site.name
}

resource "google_compute_url_map" "default" {
  name = "http-lb"

  default_service = google_compute_backend_bucket.static-site.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "path-matcher-2"
  }
  path_matcher {
    name            = "path-matcher-2"
    default_service = google_compute_backend_bucket.static-site.id

    path_rule {
      paths   = ["*"]
      service = google_compute_backend_bucket.static-site.id
    }
  }
}

# Create HTTP target proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "http-lb-proxy"
  url_map = google_compute_url_map.default.id
}

# Create forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "http-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}