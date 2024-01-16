resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_address" "static" {
  name = "my-address"
}

resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = local.machine-type
  zone         = local.zone

  tags = ["ssh-122","ssh-me"]

  boot_disk {
    initialize_params {
      image = "ubuntu-ssh-122"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "peex-network"

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_disk" "disk1" {
  name = "compute-disk1"
  zone = local.zone
  size = 10
}

resource "google_compute_disk" "disk2" {
  name = "compute-disk2"
  zone = local.zone
  size = 10
}

resource "google_compute_attached_disk" "disk1" {
  disk     = google_compute_disk.disk1.id
  instance = google_compute_instance.default.id
}

resource "google_compute_attached_disk" "disk2" {
  disk     = google_compute_disk.disk2.id
  instance = google_compute_instance.default.id
}

resource "ansible_host" "my_instance" {          #### ansible host details
  name   = google_compute_address.static.address
  groups = ["lvm"]
  variables = {
    ansible_user                 = "${var.ssh_user}",
    ansible_ssh_private_key_file = "${var.private_key_path}",
    ansible_python_interpreter   = "/usr/bin/python3"
  }
}