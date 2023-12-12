resource "google_compute_instance_template" "template" {
  name_prefix = "my-template-"

  machine_type = "f1-micro"
  region       = local.location

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  network_interface {
    network = google_compute_network.vpc_network.id
  }

tags = ["http","https","ssh"]

  disk {
    disk_type    = "pd-standard"
    source_image = "nginx"
    disk_size_gb = "10"
  }
}

resource "google_compute_region_instance_group_manager" "mig" {
  name               = "my-mig"
  base_instance_name = "mig-instance"
  region             = local.location
  target_size        = 1
  wait_for_instances = true
  named_port {
    name = "http"
    port = 80
  }

version {
  instance_template = google_compute_instance_template.template.self_link
}

  timeouts {
    create = "15m"
    update = "15m"
  }
}