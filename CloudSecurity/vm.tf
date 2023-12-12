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

   metadata_startup_script = file("scripts/startup.sh")

  tags = ["http","https","ssh","connector"]

  metadata = {
    enable-oslogin: "TRUE"
  }

  network_interface {
    network = google_compute_network.vpc_network.id

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

resource "google_compute_instance" "private" {
  name         = "private"
  machine_type = "f1-micro"
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  tags = ["ssh"]

  metadata = {
    enable-oslogin: "TRUE"
  }

  network_interface {
    network = google_compute_network.vpc_network.id
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}