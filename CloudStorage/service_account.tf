resource "google_service_account" "service_account" {
  account_id   = "test-bucket-access"
  display_name = "Service Account"
}

resource "google_service_account" "reader_service_account" {
  account_id   = "reader-service-account"
  display_name = "reader_service_account"
}

resource "google_project_iam_custom_role" "list-buckets" {
  role_id     = "listbuckets"
  title       = "list-buckets"
  permissions = ["storage.buckets.list","storage.buckets.get"]
}

resource "google_project_iam_binding" "list-buckets" {
  project = "gcp101713-michalpiasecki"
  role    = google_project_iam_custom_role.list-buckets.id
  members  = [
    "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}",
    "serviceAccount:${google_service_account.service_account.email}"
    ]
}

resource "google_storage_bucket_iam_binding" "user" {
  bucket = google_storage_bucket.auto-expire.id
  role   = "roles/storage.objectUser"
  members = [
    "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}",
    "serviceAccount:${google_service_account.service_account.email}"
    ]
}


