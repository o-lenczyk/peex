resource "google_storage_bucket" "bucket" {
  name          = "cloud-function-bucket-932344"
  location      = local.location
  force_destroy = true
  storage_class = "STANDARD"

  public_access_prevention = "enforced"

}