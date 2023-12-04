resource "google_kms_key_ring" "key_ring" {
  project  = local.project
  name     = "my-key-ring"
  location = local.location
}

resource "google_kms_crypto_key" "crypto_key" {
  name     = "my-crypto-key"
  key_ring = google_kms_key_ring.key_ring.id
}

data "google_storage_project_service_account" "gcs_account" {
}

resource "google_kms_crypto_key_iam_binding" "kms_binding" {
  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}
