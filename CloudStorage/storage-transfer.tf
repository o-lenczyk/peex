resource "google_project_service" "storagetransfer" {
  project = local.project
  service = "storagetransfer.googleapis.com"
}

resource "google_storage_bucket" "backup" {
  name          = "bucket-for-testing-storage-transfer"
  location      = "us-central1"
  force_destroy = true
  storage_class = "COLDLINE"

  encryption {
    default_kms_key_name = google_kms_crypto_key.crypto_key.id
  }

  public_access_prevention = "enforced"
  depends_on = [google_kms_crypto_key_iam_binding.kms_binding]
}

data "google_storage_transfer_project_service_account" "default" {
  project = local.project
}

resource "google_project_iam_member" "storage-transfer-user" {
  project = local.project
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${data.google_storage_transfer_project_service_account.default.email}"
}

resource "google_project_iam_member" "list-buckets-for-storage-transfer" {
  project = "gcp101713-michalpiasecki"
  role    = google_project_iam_custom_role.list-buckets.id
  member  = "serviceAccount:${data.google_storage_transfer_project_service_account.default.email}"
}

resource "google_storage_transfer_job" "backup" {
  description = "backup job"
  project     = local.project

  transfer_spec {
    transfer_options {
      delete_objects_unique_in_sink = true
    }

    gcs_data_source {
      bucket_name = google_storage_bucket.auto-expire.id
    }

    gcs_data_sink {
      bucket_name = google_storage_bucket.backup.id
    }
  }

  schedule {
    schedule_start_date {
      year  = 2023
      month = 12
      day   = 2
    }
    schedule_end_date {
      year  = 2100
      month = 12
      day   = 31
    }
    start_time_of_day {
      hours   = 21
      minutes = 30
      seconds = 0
      nanos   = 0
    }
  }
  depends_on = [ google_project_service.storagetransfer, google_project_iam_member.list-buckets-for-storage-transfer ]
}