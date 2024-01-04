resource "google_compute_network" "vnet-nebo" {
  project                 = local.project
  name                    = "vnet-nebo"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "snet-public" {
  name          = "snet-public"
  ip_cidr_range = "10.0.0.0/17"
  region        = local.location
  network       = google_compute_network.vnet-nebo.id
}

resource "google_compute_subnetwork" "snet-private" {
  name          = "snet-private"
  ip_cidr_range = "10.0.128.0/17"
  region        = local.location
  network       = google_compute_network.vnet-nebo.id
}