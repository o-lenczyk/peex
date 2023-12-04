resource "google_storage_bucket" "auto-expire" {
  name          = local.testing-bucket-name
  location      = local.location
  force_destroy = true
  storage_class = "STANDARD"

  lifecycle_rule {
    condition {
      age = 2
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 4
    }
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.crypto_key.id
  }

  public_access_prevention = "enforced"
  depends_on = [google_kms_crypto_key_iam_binding.kms_binding]
}