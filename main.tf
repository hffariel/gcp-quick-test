provider "google" {
  add_terraform_attribution_label               = true
  terraform_attribution_label_addition_strategy = "CREATION_ONLY"
  
  default_labels = {
    celerdata_cluster_name = local.celerdata_cluster_name
  }
}

resource "google_project_service" "celerdata_enabled_services" {
  for_each           = toset(local.celerdata_required_gcp_services)
  service            = each.value
  disable_on_destroy = false
}
