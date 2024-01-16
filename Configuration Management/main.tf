terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.9.0"
    }
    ansible = {
      version = "~> 1.1.0"
      source  = "ansible/ansible"
    }
  }
}

provider "google" {
  credentials = file("../key.json")

  project = local.project
  region  = local.location
  zone    = local.zone
}
