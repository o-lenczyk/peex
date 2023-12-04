resource "google_storage_bucket_object" "users" {
  name   = "users.csv"
  source = "objects/users.csv"
  bucket = google_storage_bucket.auto-expire.id

  # we want to upload file once, and then ignore the changes, and prevent overwriting
  lifecycle {
    prevent_destroy = true
    ignore_changes = [ detect_md5hash ]
  }
}

resource "google_storage_object_acl" "users-csv-acl" {
  bucket = google_storage_bucket.auto-expire.name
  object = google_storage_bucket_object.users.output_name

  role_entity = [
    "READER:user-${google_service_account.reader_service_account.email}"
  ]
}

