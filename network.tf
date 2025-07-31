
resource "google_compute_network" "celerdata_created_network" {
  project                 = data.google_client_config.current.project
  name                    = "${local.celerdata_created_resource_common_prefix}-network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  description             = "VPC network created by celerdata."

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_compute_subnetwork" "celerdata_created_subnetwork" {
  project                  = data.google_client_config.current.project
  region                   = var.region
  name                     = "${local.celerdata_created_resource_common_prefix}-subnetwork"
  ip_cidr_range            = local.celerdata_created_subnet_cird
  network                  = google_compute_network.celerdata_created_network.self_link
  private_ip_google_access = true
  description              = "Subnetwork created by celerdata."

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_compute_firewall" "celerdata_created_firewall_rule_allow_internal_ingress" {
  project         = data.google_client_config.current.project
  name            = "${local.celerdata_created_resource_common_prefix}-allow-internal-ingress"
  network         = google_compute_network.celerdata_created_network.self_link
  direction       = "INGRESS"
  priority        = 10
  source_ranges   = [local.celerdata_created_subnet_cird]
  target_tags     = [local.celerdata_cluster_network_tag]
  description = "The rule for allowing internal traffic from celerdata managed resources."

  allow {
    protocol = "all"
  }

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_compute_firewall" "celerdata_created_firewall_rule_allow_internal_egress" {
  project              = data.google_client_config.current.project
  name                 = "${local.celerdata_created_resource_common_prefix}-allow-internal-egress"
  network              = google_compute_network.celerdata_created_network.self_link
  direction            = "EGRESS"
  priority             = 10
  destination_ranges   = [local.celerdata_created_subnet_cird]
  target_tags          = [local.celerdata_cluster_network_tag]
  description          = "The rule for allowing internal traffic to celerdata managed resources."

  allow {
    protocol = "all"
  }

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_compute_firewall" "celerdata_created_firewall_rule_allow_external_egress" {
  project              = data.google_client_config.current.project
  name                 = "${local.celerdata_created_resource_common_prefix}-allow-external-egress"
  network              = google_compute_network.celerdata_created_network.self_link
  direction            = "EGRESS"
  priority             = 10
  destination_ranges   = ["0.0.0.0/0"]
  target_tags          = [local.celerdata_cluster_network_tag]
  description          = "The rule for allowing external traffic to celerdata cloud services."

  allow {
    protocol = "tcp"
    ports = ["443"]
  }

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_compute_firewall" "celerdata_created_firewall_rule_deny_external_ingress" {
  project              = data.google_client_config.current.project
  name                 = "${local.celerdata_created_resource_common_prefix}-deny-external-ingress"
  network              = google_compute_network.celerdata_created_network.self_link
  direction            = "INGRESS"
  priority             = 1000
  source_ranges        = ["0.0.0.0/0"]
  target_tags          = [local.celerdata_cluster_network_tag]
  description          = "The rule for denying all external traffic."

  deny {
    protocol = "all"
  }

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}

resource "google_compute_route" "default_internet_route" {
  project              = data.google_client_config.current.project
  name                 = "${local.celerdata_created_resource_common_prefix}-default-internet-route"
  dest_range           = "0.0.0.0/0"
  network              = google_compute_network.celerdata_created_network.self_link
  next_hop_gateway     = "default-internet-gateway"
  description          = "Route all traffic to the default internet gateway."
  priority             = 1000

  depends_on = [
    google_project_service.celerdata_enabled_services
  ]
}