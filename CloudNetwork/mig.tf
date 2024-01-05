
resource "google_compute_instance_template" "blue" {
  name        = "appserver-template-blue"
  description = "This template is used to create app server instances."

  labels = {
    environment = "dev"
  }

    metadata = {
    startup-script = <<-EOF1
      #! /bin/bash
      set -euo pipefail

      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y nginx-light jq

      NAME=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/hostname")
      IP=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip")
      METADATA=$(curl -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/?recursive=True" | jq 'del(.["startup-script"])')

      cat <<EOF > /var/www/html/index.html
      <pre>
      Name: $NAME
      IP: $IP
      Metadata: $METADATA
      </pre>
      EOF
    EOF1
  }

  instance_description = "description assigned to instances"
  machine_type         = "f1-micro"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image      = "ubuntu-ssh-122"
    auto_delete       = true
    boot              = true
  }

tags = ["http","https","ssh","connector", "allow-health-check"]

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

resource "google_compute_instance_template" "green" {
  name        = "appserver-template-green"
  description = "This template is used to create app server instances."

  labels = {
    environment = "dev"
  }

  instance_description = "description assigned to instances"
  machine_type         = "f1-micro"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image

  
  disk {
    source_image      = "ubuntu-ssh-122"
    auto_delete       = true
    boot              = true
  }

    tags = ["http","https","ssh","connector", "allow-health-check"]

  network_interface {
    subnetwork = google_compute_subnetwork.snet-public.id
        access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_target_pool" "foobar" {
  name = "my-target-pool"
}

resource "google_compute_instance_group_manager" "foobar" {
  name = "my-igm"
  zone = local.zone
  target_size = 2
  named_port {
    name = "http"
    port = 80
  }

  version {
    instance_template  = google_compute_instance_template.blue.id
    name               = "primary"
  }

  target_pools       = [google_compute_target_pool.foobar.id]
  base_instance_name = "foobar"
}