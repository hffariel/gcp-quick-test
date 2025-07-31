provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "celerdata_enabled_services" {
  project = var.project_id
  for_each = toset(local.celerdata_required_gcp_services)
  service = each.value
  disable_on_destroy = false
}
