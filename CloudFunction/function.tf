data "archive_file" "default" {
  type        = "zip"
  output_path = "/tmp/function-source.zip"
  source_dir  = "scripts"
}

resource "google_storage_bucket_object" "archive" {
  name   = "sourcecode.${data.archive_file.default.output_md5}.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.default.output_path
}

resource "google_cloudfunctions2_function" "function" {
  name = "function-v2"
  location = local.location
  description = "a new function"

  build_config {
    runtime = "python312"
    entry_point = "hello_http"  # Set the entry point 
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.archive.name
      }
    }
  }

  service_config {
    max_instance_count  = 1
    available_memory    = "256M"
    timeout_seconds     = 60
  }
}

resource "google_cloudfunctions2_function_iam_member" "invoker" {
  project        = google_cloudfunctions2_function.function.project
  location       = google_cloudfunctions2_function.function.location
  cloud_function = google_cloudfunctions2_function.function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:${google_service_account.service_account.email}"
}