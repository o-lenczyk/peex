resource "google_service_account" "os-login" {
  account_id   = "sa-for-os-login"
  display_name = "Custom SA for VM Instance"
}

resource "google_os_login_ssh_public_key" "cache" {
  user = data.google_client_openid_userinfo.me.email
  key  = file("keys/id_rsa.pub")
}

resource "google_project_iam_member" "project" {
  project = local.project
  role    = "roles/compute.osAdminLogin"
  member  = "serviceAccount:${data.google_client_openid_userinfo.me.email}"
}
