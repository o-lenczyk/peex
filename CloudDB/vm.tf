resource "google_service_account" "default" {
  account_id   = "sa-for-vm"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "public" {
  name         = "public"
  machine_type = "f1-micro"
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = "nginx2"
      labels = {
        my_label = "value"
      }
    }
  }

  tags = ["http","https","ssh","connector"]

  metadata = {
    enable-oslogin: "TRUE"
  }

  network_interface {
    network = data.google_compute_network.redis-network.id

    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}