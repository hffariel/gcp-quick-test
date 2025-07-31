provider "google" {
  project_id = data.google_client_config.current.project
}

data "google_client_config" "current" {
}

resource "google_project_service" "celerdata_enabled_services" {
  project            = data.google_client_config.current.project
  for_each           = toset(local.celerdata_required_gcp_services)
  service            = each.value
  disable_on_destroy = false
}
