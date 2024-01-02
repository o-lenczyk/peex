resource "google_firestore_database" "database" {
  project                 = local.project
  name                    = "(default)"
  location_id             = "nam5"
  type                    = "FIRESTORE_NATIVE"
  delete_protection_state = "DELETE_PROTECTION_DISABLED"
  deletion_policy         = "DELETE"
}