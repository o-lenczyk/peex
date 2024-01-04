resource "google_service_account" "default" {
  account_id   = "sa-for-vm-2"
  display_name = "Custom SA for VM Instance"
}

resource "google_project_iam_binding" "oslogin" {
  project = "gcp101713-michalpiasecki"
  role    = "roles/compute.osLogin"
  members  = [
    "serviceAccount:${google_service_account.default.email}",
    ]
}

resource "google_project_iam_binding" "computeviewer" {
  project = "gcp101713-michalpiasecki"
  role    = "roles/compute.viewer"
  members  = [
    "serviceAccount:${google_service_account.default.email}",
    ]
}

resource "google_project_iam_binding" "iap" {
  project = "gcp101713-michalpiasecki"
  role    = "roles/iap.tunnelResourceAccessor"
  members  = [
    "serviceAccount:${google_service_account.default.email}",
    ]
}

resource "google_compute_instance" "vm1" {
  name         = "vm1"
  machine_type = "f1-micro"
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  tags = ["http","https","ssh","connector"]

  metadata = {
    enable-oslogin: "TRUE"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.snet-private.id

  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_instance" "vm2" {
  name         = "vm2"
  machine_type = "f1-micro"
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  tags = ["http","https","ssh","connector"]

  metadata = {
    enable-oslogin: "TRUE"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.snet-public.id

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

resource "google_compute_instance" "vm-nebo1" {
  name         = "vm-nebo1"
  machine_type = "f1-micro"
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  tags = ["ssh","rdp","block-egress"]

  metadata = {
    enable-oslogin: "TRUE"
    ssh-keys = "mpiase_softserveinc_com:${file("keys/id_rsa.pub")}"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.snet-public.id

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