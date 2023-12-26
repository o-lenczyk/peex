resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = local.zone
  deletion_protection = false

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  network = google_compute_network.vpc_network.id 

  notification_config {
    pubsub {
      enabled = true
      topic = google_pubsub_topic.example.id
    }
  }

  maintenance_policy {
  daily_maintenance_window {
    start_time = "03:00"
  }
}
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-primary-node-pool"
  cluster    = google_container_cluster.primary.id
  location   = local.zone
  node_locations = [ local.zone ]
  node_count = 1

  upgrade_settings {
    strategy = "BLUE_GREEN"
    blue_green_settings {
      node_pool_soak_duration = "60s" 
      standard_rollout_policy {
         batch_node_count = 1
      }
    }
  }  

  node_config {
    preemptible  = true
    machine_type = "g1-small"
    

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "secondary_preemptible_nodes" {
  name       = "my-secondary-node-pool"
  cluster    = google_container_cluster.primary.id
  location   = local.zone
  node_locations = [ local.zone ]
  node_count = 1

  upgrade_settings {
    strategy = "BLUE_GREEN"
    blue_green_settings {
      node_pool_soak_duration = "60s" 
      standard_rollout_policy {
         batch_node_count = 1
      }
    }
  }

  node_config {
    preemptible  = true
    machine_type = "g1-small"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}