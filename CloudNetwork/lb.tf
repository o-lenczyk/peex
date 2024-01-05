# reserved IP address
resource "google_compute_global_address" "default" {
  project = local.project
  name     = "l7-xlb-static-ip"
}

# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "l7-xlb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

# http proxy
resource "google_compute_target_http_proxy" "default" {
  name     = "l7-xlb-target-http-proxy"
  url_map  = google_compute_url_map.default.id
}

# url map
resource "google_compute_url_map" "default" {
  name            = "l7-xlb-url-map"
  default_service = google_compute_backend_service.default.id
}

# health check
resource "google_compute_health_check" "default" {
  name     = "l7-xlb-hc"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

# backend service with custom request and response headers
resource "google_compute_backend_service" "default" {
  name                    = "l7-xlb-backend-service"
  protocol                = "HTTP"
  port_name               = "http"
  load_balancing_scheme   = "EXTERNAL"
  timeout_sec             = 10
  enable_cdn              = true
  custom_request_headers  = ["X-Client-Geo-Location: {client_region_subdivision}, {client_city}"]
  custom_response_headers = ["X-Cache-Hit: {cdn_cache_status}"]
  health_checks           = [google_compute_health_check.default.id]
  backend {
    group           = google_compute_instance_group_manager.foobar.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

# allow access from health check ranges
resource "google_compute_firewall" "default" {
  name          = "l7-xlb-fw-allow-hc"
  direction     = "INGRESS"
  network       = google_compute_network.vnet-nebo.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}
