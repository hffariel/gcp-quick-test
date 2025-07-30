provider "google" {
  project = var.project_id
  region  = var.gcp_region
}

resource "google_project_services" "celerdata_enabled_services" {
  project = var.project_id

  services = [
    "compute.googleapis.com",
    "storage.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com"
  ]
  disable_on_destroy = false
}
