resource "google_kms_key_ring" "key_ring" {
  project  = local.project
  name     = "key-ring"
  location = local.location
}

resource "google_kms_crypto_key" "crypto_key" {
  name     = "crypto-key"
  key_ring = google_kms_key_ring.key_ring.id
}

resource "google_kms_crypto_key_iam_binding" "kms_binding" {
  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}

resource "google_storage_bucket" "auto-expire" {
  name          = local.bucket-name
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

  encryption {
    default_kms_key_name = google_kms_crypto_key.crypto_key.id
  }

  retention_policy {
    retention_period = 86400
  }

# versioning cannot be used together with retention policy
#   versioning {
#     enabled = true
#   }

  public_access_prevention = "enforced"
  depends_on = [google_kms_crypto_key_iam_binding.kms_binding]
}

#Forbidden by PrismaCloud
# resource "google_storage_bucket_iam_member" "member" {
#   bucket = google_storage_bucket.auto-expire.name
#   role   = "roles/storage.objectViewer"
#   member = "allUsers"
# }