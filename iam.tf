resource "google_project_iam_custom_role" "celerdata_created_vm_data_role" {
  project     = local.project_id
  role_id     = "${replace(local.celerdata_created_resource_common_prefix, "-", "_")}_vm_data_role_id"
  title       = "${replace(local.celerdata_created_resource_common_prefix, "-", "_")}_vm_data_role"
  permissions = ["iam.serviceAccounts.signBlob", "storage.buckets.get", "storage.buckets.update", "storage.objects.create", "storage.objects.delete", "storage.objects.get", "storage.objects.list", "storage.objects.update"]
  description = "The cloud storage data role created by celerdata"
}

resource "google_service_account" "celerdata_created_vm_service_account" {
  project      = local.project_id
  account_id   = "${local.celerdata_created_resource_common_prefix}"
  display_name = "${local.celerdata_created_resource_common_prefix}-vm-sa"
  description  = "The service account bound with VMs created by celerdata."
}

resource "google_project_iam_member" "celerdata_created_vm_service_account_binding" {
  project = local.project_id
  member  = "serviceAccount:${google_service_account.celerdata_created_vm_service_account.email}"
  role    = google_project_iam_custom_role.celerdata_created_vm_data_role.name
}

resource "google_project_iam_custom_role" "celerdata_created_deployment_extra_role" {
  project     = local.project_id
  role_id     = "${replace(local.celerdata_created_resource_common_prefix, "-", "_")}"
  title       = "${replace(local.celerdata_created_resource_common_prefix, "-", "_")}_deployment_role"
  permissions = ["iam.serviceAccounts.actAs", "storage.buckets.get"]
  description = "The cluster deployment role created by celerdata"
}

resource "google_project_iam_member" "celerdata_deployment_compute_admin_binding" {
  project = local.project_id
  member  = "serviceAccount:${var.celerdata_service_account_email}"
  role    = "roles/compute.admin"
}

resource "google_project_iam_member" "celerdata_deployment_extra_binding" {
  project = local.project_id
  member  = "serviceAccount:${var.celerdata_service_account_email}"
  role    = google_project_iam_custom_role.celerdata_created_deployment_extra_role.name
}