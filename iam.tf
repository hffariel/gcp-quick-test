
resource "google_project_iam_custom_role" "celerdata_created_vm_data_role" {
  project     = data.google_project.project.number
  role_id     = "${replace(local.celerdata_created_resource_common_prefix, "-", "_")}_vm_data_role_id"
  title       = "${replace(local.celerdata_created_resource_common_prefix, "-", "_")}_vm_data_role"
  permissions = ["iam.serviceAccounts.signBlob", "storage.buckets.get", "storage.buckets.update", "storage.objects.create", "storage.objects.delete", "storage.objects.get", "storage.objects.list", "storage.objects.update"]
  description = "The cloud storage data role created by celerdata"

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_service_account" "celerdata_created_vm_service_account" {
  project      = data.google_project.project.number
  account_id   = "${local.celerdata_created_resource_common_prefix}"
  display_name = "${local.celerdata_created_resource_common_prefix}-vm-sa"
  description  = "The service account bound with VMs created by celerdata."

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_project_iam_member" "celerdata_created_vm_service_account_binding" {
  project = data.google_project.project.number
  member  = "serviceAccount:${google_service_account.celerdata_created_vm_service_account.email}"
  role    = google_project_iam_custom_role.celerdata_created_vm_data_role.name

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_project_iam_custom_role" "celerdata_created_deployment_extra_role" {
  project     = data.google_project.project.number
  role_id     = "${replace(local.celerdata_created_resource_common_prefix, "-", "_")}"
  title       = "${replace(local.celerdata_created_resource_common_prefix, "-", "_")}_deployment_role"
  permissions = ["iam.serviceAccounts.actAs", "storage.buckets.get"]
  description = "The cluster deployment role created by celerdata"

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_project_iam_member" "celerdata_deployment_compute_admin_binding" {
  project = data.google_project.project.number
  member  = "serviceAccount:${var.celerdata_service_account_email}"
  role    = "roles/compute.admin"

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_project_iam_member" "celerdata_deployment_extra_binding" {
  project = data.google_project.project.number
  member  = "serviceAccount:${var.celerdata_service_account_email}"
  role    = google_project_iam_custom_role.celerdata_created_deployment_extra_role.name

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}