resource "google_project_service" "iap" {
  project = local.project
  service = "iap.googleapis.com"
}

module "iap_tunneling" {
  source = "terraform-google-modules/bastion-host/google//modules/iap-tunneling"

  project                    = local.project
  network                    = google_compute_network.vpc_network.id
  service_accounts           = [ google_service_account.default.email ]

  instances = [{
    name = google_compute_instance.private.name
    zone = google_compute_instance.private.zone
  }]

  members = [
    "serviceAccount:${data.google_client_openid_userinfo.me.email}",
  ]

  depends_on = [ google_project_service.iap ]
}