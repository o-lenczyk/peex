resource "google_compute_network" "vpc_network" {
  project                 = local.project
  name                    = "peex-network2"
  auto_create_subnetworks = true
}