data "google_compute_network" "redis-network" {
  name = "peex-network"
}

data "google_client_openid_userinfo" "me" {}