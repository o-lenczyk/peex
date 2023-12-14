terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.9.0"
    }
  }
}

provider "google" {
  credentials = file("../key.json")

  project = local.project
  region  = local.location
  zone    = local.zone
}
