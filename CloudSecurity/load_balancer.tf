resource "google_compute_global_address" "lb-static-ip" {
  provider = google
  project  = local.project
  name     = "lb-static-ip"
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "forwarding-rule"
  project               = local.project
  provider              = google
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.lb-static-ip.id
}

resource "google_compute_target_http_proxy" "default" {
  name     = "http-proxy"
  project  = local.project
  provider = google
  url_map  = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  project         = local.project
  name            = "l7-xlb-url-map"
  provider        = google
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_health_check" "default" {
  name     = "hc"
  project  = local.project
  provider = google
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_backend_service" "default" {
  name                    = "lb"
  project                 = local.project
  provider                = google
  protocol                = "HTTP"
  port_name               = "http"
  load_balancing_scheme   = "EXTERNAL"
  security_policy         = module.security_policy.policy.id
  timeout_sec             = 10
  enable_cdn              = true
  health_checks           = [google_compute_health_check.default.id]
  backend {
    group           = google_compute_region_instance_group_manager.mig.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}
