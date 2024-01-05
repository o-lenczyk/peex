resource "google_service_account" "default" {
  account_id   = "sa-for-vm-2"
  display_name = "Custom SA for VM Instance"
}
