resource "google_cloud_scheduler_job" "job" {
  name             = "cloud-function-tutorial-scheduler"
  description      = "Trigger the ${google_cloudfunctions2_function.function.name} Cloud Function every 10 mins."
  schedule         = "0 * * * *" # Every 1h
  time_zone        = "Europe/Dublin"
  attempt_deadline = "320s"

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions2_function.function.url

    oidc_token {
      service_account_email = data.google_client_openid_userinfo.me.email
    }
  }
}