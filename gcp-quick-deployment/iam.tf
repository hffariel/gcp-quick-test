resource "google_project_iam_custom_role" "celerdata_created_vm_data_role" {
  project     = var.project_id
  role_id     = "${replace(local.celerdata_created_resource_common_prefix, "-", "_")}_vm_data_role_id"
  title       = "${replace(local.celerdata_created_resource_common_prefix, "-", "_")}_vm_data_role"
  permissions = ["iam.serviceAccounts.signBlob", "storage.buckets.get", "storage.buckets.update", "storage.objects.create", "storage.objects.delete", "storage.objects.get", "storage.objects.list", "storage.objects.update"]
  description = "The cloud storage data role created by celerdata"

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_service_account" "celerdata_created_vm_service_account" {
  project      = var.project_id
  account_id   = "${local.celerdata_created_resource_common_prefix}"
  display_name = "${local.celerdata_created_resource_common_prefix}-vm-sa"
  description  = "The service account bound with VMs created by celerdata."

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_project_iam_member" "celerdata_created_vm_service_account_binding" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.celerdata_created_vm_service_account.email}"
  role    = google_project_iam_custom_role.celerdata_created_vm_data_role.name

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

data "google_iam_role" "compute_admin_role" {
  name = "roles/compute.admin"
}

locals {
  celerdata_required_permissions = [
    "compute.addresses.create", "compute.addresses.delete", "compute.addresses.get", "compute.addresses.list", "compute.addresses.setLabels", "compute.addresses.use",
    "compute.globalAddresses.create", "compute.globalAddresses.delete", "compute.globalAddresses.get", "compute.globalAddresses.list", "compute.globalAddresses.setLabels", "compute.globalAddresses.use",
    "compute.backendServices.create", "compute.backendServices.delete", "compute.backendServices.get", "compute.backendServices.list", "compute.backendServices.update", "compute.backendServices.use",
    "compute.regionBackendServices.create", "compute.regionBackendServices.delete", "compute.regionBackendServices.get", "compute.regionBackendServices.list", "compute.regionBackendServices.update", "compute.regionBackendServices.use",
    "compute.disks.create", "compute.disks.delete", "compute.disks.get", "compute.disks.list", "compute.disks.resize", "compute.disks.update", "compute.disks.setLabels", "compute.disks.use",
    "compute.healthChecks.create", "compute.healthChecks.delete", "compute.healthChecks.get", "compute.healthChecks.list", "compute.healthChecks.update", "compute.healthChecks.use",
    "compute.regionHealthChecks.create", "compute.regionHealthChecks.delete", "compute.regionHealthChecks.get", "compute.regionHealthChecks.list", "compute.regionHealthChecks.update", "compute.regionHealthChecks.use",
    "compute.regionHealthCheckServices.create", "compute.regionHealthCheckServices.delete", "compute.regionHealthCheckServices.get", "compute.regionHealthCheckServices.list", "compute.regionHealthCheckServices.update", "compute.regionHealthCheckServices.use",
    "compute.httpHealthChecks.create", "compute.httpHealthChecks.delete", "compute.httpHealthChecks.get", "compute.httpHealthChecks.list", "compute.httpHealthChecks.update", "compute.httpHealthChecks.useReadOnly",
    "compute.httpsHealthChecks.create", "compute.httpsHealthChecks.delete", "compute.httpsHealthChecks.get", "compute.httpsHealthChecks.list", "compute.httpsHealthChecks.update", "compute.httpsHealthChecks.useReadOnly",
    "compute.instanceGroupManagers.create", "compute.instanceGroupManagers.delete", "compute.instanceGroupManagers.get", "compute.instanceGroupManagers.list", "compute.instanceGroupManagers.update", "compute.instanceGroupManagers.use",
    "compute.instanceGroups.create", "compute.instanceGroups.delete", "compute.instanceGroups.get", "compute.instanceGroups.list", "compute.instanceGroups.update", "compute.instanceGroups.use",
    "compute.resourcePolicies.create", "compute.resourcePolicies.delete", "compute.resourcePolicies.get", "compute.resourcePolicies.list", "compute.resourcePolicies.update", "compute.resourcePolicies.use",
    "compute.forwardingRules.create", "compute.forwardingRules.delete", "compute.forwardingRules.get", "compute.forwardingRules.list", "compute.forwardingRules.setLabels", "compute.forwardingRules.setTarget", "compute.forwardingRules.update", "compute.forwardingRules.use",
    "compute.instances.addNetworkInterface", "compute.instances.attachDisk", "compute.instances.create", "compute.instances.delete", "compute.instances.deleteNetworkInterface", "compute.instances.detachDisk", "compute.instances.get", "compute.instances.getEffectiveFirewalls", "compute.instances.getSerialPortOutput", "compute.instances.list", "compute.instances.reset", "compute.instances.resume", "compute.instances.setDeletionProtection", "compute.instances.setDiskAutoDelete", "compute.instances.setLabels", "compute.instances.setMachineType", "compute.instances.setMetadata", "compute.instances.setMinCpuPlatform", "compute.instances.setName", "compute.instances.setScheduling", "compute.instances.setServiceAccount", "compute.instances.start", "compute.instances.stop", "compute.instances.suspend", "compute.instances.update", "compute.instances.updateNetworkInterface", "compute.instances.use",
    "compute.instanceSettings.get", "compute.instanceSettings.update",
    "compute.diskSettings.get", "compute.diskSettings.update",
    "compute.diskTypes.get", "compute.diskTypes.list",
    "compute.externalVpnGateways.get", "compute.externalVpnGateways.list",
    "compute.firewallPolicies.get", "compute.firewallPolicies.list",
    "compute.regionFirewallPolicies.get", "compute.regionFirewallPolicies.list",
    "compute.firewalls.get", "compute.firewalls.list",
    "compute.firewalls.get", "compute.firewalls.list",
    "compute.globalForwardingRules.get", "compute.globalForwardingRules.list",
    "compute.globalNetworkEndpointGroups.get", "compute.globalNetworkEndpointGroups.list",
    "compute.images.get", "compute.images.list", "compute.images.useReadOnly",
    "compute.machineImages.get", "compute.machineImages.list", "compute.machineImages.useReadOnly",
    "compute.machineTypes.get", "compute.machineTypes.list",
    "compute.networkAttachments.get", "compute.networkAttachments.list",
    "compute.routers.get", "compute.routers.list",
    "compute.routes.get", "compute.routes.list",
    "compute.subnetworks.get", "compute.subnetworks.list", "compute.subnetworks.use", "compute.subnetworks.useExternalIp",
    "compute.serviceAttachments.get", "compute.serviceAttachments.list", "compute.serviceAttachments.use",
    "compute.regions.get", "compute.regions.list",
    "compute.zones.get", "compute.zones.list",
    "compute.networks.get", "compute.networks.getEffectiveFirewalls", "compute.networks.getRegionEffectiveFirewalls", "compute.networks.list", "compute.networks.listPeeringRoutes", "compute.networks.use", "compute.networks.useExternalIp", 
    "compute.projects.get", 
    "iam.serviceAccounts.actAs", "storage.buckets.get"
  ]
}

resource "google_project_iam_custom_role" "celerdata_created_deployment_role" {
  project     = var.project_id
  role_id     = "${replace(local.celerdata_created_resource_common_prefix, "-", "_")}"
  title       = "${replace(local.celerdata_created_resource_common_prefix, "-", "_")}_deployment_role"
  permissions = local.celerdata_required_permissions
  description = "The cluster deployment role created by celerdata"

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_project_iam_member" "celerdata_deployment_role_binding" {
  project = var.project_id
  member  = "serviceAccount:${var.celerdata_service_account_email}"
  role    = google_project_iam_custom_role.celerdata_created_deployment_role.name

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}