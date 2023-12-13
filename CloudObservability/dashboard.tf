resource "google_project_service" "monitoring" {
  project = local.project
  service = "monitoring.googleapis.com"
}

resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = file("dashboard/dashboard.json")
}
