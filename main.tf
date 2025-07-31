provider "google" {
}

data "google_project" "project" {
}

resource "google_project_service" "celerdata_enabled_services" {
  project            = data.google_project.project.number
  for_each           = toset(local.celerdata_required_gcp_services)
  service            = each.value
  disable_on_destroy = false
}
