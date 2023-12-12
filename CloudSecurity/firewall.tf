resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["122"]
  }

  target_tags = ["ssh"]
}

resource "google_compute_firewall" "http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["http"]
}

resource "google_compute_firewall" "https" {
  name    = "allow-https"
  network = google_compute_network.vpc_network.name

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["https"]
}

resource "google_compute_firewall" "vpc-connector" {
  name    = "vpc-connector"
  network = google_compute_network.vpc_network.name

  source_ranges = ["35.199.224.0/19"]

  allow {
    protocol = "tcp"
  }

  target_tags = ["connector"]
}