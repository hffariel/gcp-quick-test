
resource "google_storage_bucket" "celerdata_created_data_bucket" {
  project       = var.project_id
  name          = "${local.celerdata_created_resource_common_prefix}-data-bucket"
  location      = var.region
  storage_class = "REGIONAL"
  force_destroy = false

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}