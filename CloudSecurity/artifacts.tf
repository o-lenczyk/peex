resource "google_artifact_registry_repository" "docker" {
  location      = local.location
  repository_id = "docker-repository"
  description   = "example docker repository"
  format        = "DOCKER"
}

resource "google_project_iam_binding" "docker-pull" {
  project = local.project
  role    = "roles/artifactregistry.writer"
  members  = ["serviceAccount:${google_service_account.default.email}"]
}

resource "google_artifact_registry_repository" "apt" {
  location      = local.location
  repository_id = "debian-buster"
  description   = "example remote apt repository"
  format        = "APT"
}

resource "google_artifact_registry_repository" "python" {
  location      = local.location
  repository_id = "python-repository"
  description   = "example remote apt repository"
  format        = "PYTHON"
}
