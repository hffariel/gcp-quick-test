output "celerdata_cluster_storage_bucket" {
  value = google_storage_bucket.celerdata_created_data_bucket.url
}

output "celerdata_cluster_vm_service_account" {
  value = google_service_account.celerdata_created_vm_service_account.email
}

output "celerdata_cluster_network" {
  value = google_compute_network.celerdata_created_network.id
}

output "celerdata_cluster_subnetwork" {
  value = google_compute_subnetwork.celerdata_created_subnetwork.id
}

output "celerdata_cluster_network_tag" {
  value = local.celerdata_cluster_network_tag
}

output "celerdata_cluster_initial_admin_password" {
  value = random_password.celerdata_cluster_initial_admin_password.result
  sensitive = true
}

output "celerdata_cluster_preview_address" {
  value = "https://${var.celerdata_cloud_api_host}/add-cluster?oid=${local.order_id}&csp=${local.csp_id}" 
}