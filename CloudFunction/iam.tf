resource "google_service_account" "service_account" {
  account_id   = "cloud-function"
  display_name = "Service Account"
}

resource "google_storage_bucket_iam_binding" "user" {
  bucket = google_storage_bucket.bucket.id
  role   = "roles/storage.objectUser"
  members = [
    "serviceAccount:${google_service_account.service_account.email}"
    ]
}