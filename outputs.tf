output "celerdata_created_storage_bucket" {
  value = google_storage_bucket.celerdata_created_data_bucket.url
}

output "celerdata_created_vm_service_account" {
  value = google_service_account.celerdata_created_vm_service_account.email
}

output "celerdata_created_network" {
  value = google_compute_network.celerdata_created_network.self_link
}

output "celerdata_created_subnetwork" {
  value = google_compute_subnetwork.celerdata_created_subnetwork.self_link
}

output "celerdata_used_cluster_network_tag" {
  value = local.celerdata_cluster_network_tag
}