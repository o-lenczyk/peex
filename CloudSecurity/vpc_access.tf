resource "google_project_service" "vpcaccess-api" {
  project = local.project
  service = "vpcaccess.googleapis.com"
}

resource "google_compute_subnetwork" "test2" {
  name          = "test2-subnetwork"
  ip_cidr_range = "10.100.0.0/28"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

module "serverless-connector" {
  source     = "terraform-google-modules/network/google//modules/vpc-serverless-connector-beta"
  version    = "~> 8.0"
  project_id = local.project
  vpc_connectors = [{
    name        = "central-serverless2"
    region      = "us-central1"
    subnet_name = google_compute_subnetwork.test2.name
    # host_project_id = var.host_project_id # Specify a host_project_id for shared VPC
    machine_type  = "f1-micro"
    target_tags = "connector"
    # min_instances = 2
    # max_instances = 3
    }
    # Uncomment to specify an ip_cidr_range
    #   , {
    #     name          = "central-serverless2"
    #     region        = "us-central1"
    #     network       = module.test-vpc-module.network_name
    #     ip_cidr_range = "10.10.11.0/28"
    #     subnet_name   = null
    #     machine_type  = "e2-standard-4"
    #     min_instances = 2
    #   max_instances = 7 }
  ]
  depends_on = [
    google_project_service.vpcaccess-api
  ]
}