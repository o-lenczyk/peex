resource "google_compute_autoscaler" "foobar" {
  name   = "my-autoscaler"
  zone   = local.zone
  target = google_compute_instance_group_manager.foobar.id

  autoscaling_policy {
    max_replicas    = 10
    min_replicas    = 2
    cooldown_period = 600
    

    cpu_utilization {
      target = 0.7
    }

    scaling_schedules {
    name = "every-weekday-morning"
    description = "Increase to 10 every weekday at 9AM for 12 hours."
    min_required_replicas = 10
    schedule = "0 9 * * 0-5"
    time_zone = "America/New_York"
    duration_sec = 86400
    }

    scaling_schedules {
    name = "weekends"
    description = "weekend"
    min_required_replicas = 3
    schedule = "0 18 * * 6-7"
    time_zone = "America/New_York"
    duration_sec = 86400
    }

  }  
}

resource "google_compute_instance_template" "template" {
  name_prefix = "my-template-"

  machine_type = "custom-1-1024"
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
    source_image = "nginx2"
    disk_size_gb = "10"
  }
}

resource "google_compute_target_pool" "foobar" {
  name = "my-target-pool"
}

resource "google_compute_instance_group_manager" "foobar" {
  name = "my-igm"
  zone = local.zone

  version {
    instance_template  = google_compute_instance_template.template.id
    name               = "primary"
  }

  target_pools       = [google_compute_target_pool.foobar.id]
  base_instance_name = "foobar"
}