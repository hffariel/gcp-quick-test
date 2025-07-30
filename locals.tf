resource "random_string" "celerdata_recource_suffix" {
  special = false
  upper   = false
  lower   = true
  length  = 5
}

locals {
  celerdata_created_resource_common_prefix = "celerdata-${var.celerdata_cluster_name}-${random_string.celerdata_recource_suffix.result}"
}

locals {
  celerdata_created_subnet_cird            = "10.1.0.0/16"
  celerdata_cluster_network_tag            = "${local.celerdata_created_resource_common_prefix}-network-tag"
}