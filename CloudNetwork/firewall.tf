resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vnet-nebo.name

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["122"]
  }

  target_tags = ["ssh"]
}

resource "google_compute_firewall" "allow-rdp" {
  name    = "rdp"
  network = google_compute_network.vnet-nebo.name

  source_ranges = ["217.97.82.91"]

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  target_tags = ["rdp"]
}

resource "google_compute_firewall" "block-egress" {
  name    = "block-egress"
  direction = "EGRESS"
  network = google_compute_network.vnet-nebo.name
  
  deny {
    protocol = "tcp"
  }

  deny {
    protocol = "udp"
  }

  target_tags = ["block-egress"]
}