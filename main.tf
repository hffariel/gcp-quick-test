provider "google" {
  add_terraform_attribution_label               = true
  terraform_attribution_label_addition_strategy = "CREATION_ONLY"
  
  default_labels = {
    celerdata_cluster_name = var.celerdata_cluster_name
  }
}

resource "random_string" "celerdata_recource_suffix" {
  special = false
  upper   = false
  lower   = true
  length  = 5
}

resource "google_project_service" "celerdata_enabled_services" {
  for_each           = toset(local.celerdata_required_gcp_services)
  service            = each.value
  disable_on_destroy = false
}

locals {
  project_id                               = var.project_id != "" ? var.project_id : split("/", google_project_service.celerdata_enabled_services[local.celerdata_required_gcp_services[0]].id)[0]
  region                                   = var.region != "" ? var.region : env("GOOGLE_REGION")
  celerdata_created_resource_common_prefix = "cd-${var.celerdata_cluster_name}-${random_string.celerdata_recource_suffix.result}"
}

locals {
  celerdata_created_subnet_cird   = "10.1.0.0/16"
  celerdata_cluster_network_tag   = "${local.celerdata_created_resource_common_prefix}-network-tag"
  celerdata_required_gcp_services = [
    "compute.googleapis.com",
    "storage.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "sqladmin.googleapis.com",
    "run.googleapis.com"
  ]
}