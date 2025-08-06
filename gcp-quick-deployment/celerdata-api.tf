locals {
  sign_in                        = jsondecode(base64decode(var.celerdata_cloud_api_credential))
  create_credential_request_body = jsonencode({
    credential = {
      role_arn       = var.celerdata_service_account_email
      external_id    = var.project_id
      policy_version = "gcp-quick-deployment"
    }
    quickStartUUID = local.sign_in.quickStartUUID
  })
}

resource "time_sleep" "wait_for_permissions_ready" {
  depends_on = [
    google_project_iam_member.celerdata_deployment_role_binding,
    google_compute_subnetwork.celerdata_created_subnetwork
  ]
  create_duration = "60s"
}

resource "random_uuid" "celerdata_save_credential_nonce" {}
resource "time_static" "celerdata_save_credential_timestamp" {
  triggers = {
    refresh = timestamp()
  }
}

data "http" "create_credential" {
  url    = "https://${var.celerdata_cloud_api_host}/api/quickstart/create-credential"
  method = "POST"
  request_body = local.create_credential_request_body
  request_headers = {
    "Content-Type"    = "application/json"
    "Accept-Language" = "en-us"
    "x-sr-ubid"       = local.sign_in.ubid
    "x-sr-token"      = local.sign_in.token
    "x-sr-nonce"      = random_uuid.celerdata_save_credential_nonce.result
    "x-sr-timestamp"  = time_static.celerdata_save_credential_timestamp.unix * 1000
    "x-sr-signature" = sha256(join("", [
      local.sign_in.ubid,
      local.sign_in.token,
      random_uuid.celerdata_save_credential_nonce.result,
      time_static.celerdata_save_credential_timestamp.unix * 1000,
      local.create_credential_request_body
    ]))
  }
  depends_on = [
    time_sleep.wait_for_permissions_ready
  ]
}

locals {
  credential_response         = jsondecode(data.http.create_credential.response_body)
  credential_id               = local.credential_response.data == null ? "" : local.credential_response.data.credentialId
  create_network_request_body = jsonencode({
    networkInterface = {
      subnet_id         = google_compute_subnetwork.celerdata_created_subnetwork.name
      security_group_id = local.celerdata_cluster_network_tag
    }
    credential_id  = local.credential_id
    quickStartUUID = local.sign_in.quickStartUUID
  })
}

resource "random_uuid" "celerdata_save_network_nonce" {}
resource "time_static" "celerdata_save_network_timestamp" {
  triggers = {
    refresh = timestamp()
  }
}

data "http" "create_network" {
  url    = "https://${var.celerdata_cloud_api_host}/api/quickstart/create-network"
  method = "POST"
  request_body = local.create_network_request_body
  request_headers = {
    "Content-Type"    = "application/json"
    "Accept-Language" = "en-us"
    "x-sr-ubid"       = local.sign_in.ubid
    "x-sr-token"      = local.sign_in.token
    "x-sr-nonce"      = random_uuid.celerdata_save_network_nonce.result
    "x-sr-timestamp"  = time_static.celerdata_save_network_timestamp.unix * 1000
    "x-sr-signature" = sha256(join("", [
      local.sign_in.ubid,
      local.sign_in.token,
      random_uuid.celerdata_save_network_nonce.result,
      time_static.celerdata_save_network_timestamp.unix * 1000,
      local.create_network_request_body
    ]))
  }
}

locals {
  network_response                   = jsondecode(data.http.create_network.response_body)
  net_iface_id                       = local.network_response.data == null ? "" : local.network_response.data.netIfaceId
  create_storage_config_request_body = jsonencode({
    storage_conf = {
      bucket_name          = replace(google_storage_bucket.celerdata_created_data_bucket.url, "gs://", "")
      instance_profile_arn = google_service_account.celerdata_created_vm_service_account.email
    }
    credential_id  = local.credential_id
    quickStartUUID = local.sign_in.quickStartUUID
  })
}

resource "random_uuid" "celerdata_save_storage_nonce" {}
resource "time_static" "celerdata_save_storage_timestamp" {
  triggers = {
    refresh = timestamp()
  }
}

data "http" "create_storage_config" {
  url    = "https://${var.celerdata_cloud_api_host}/api/quickstart/create-storage-config"
  method = "POST"
  request_body = local.create_storage_config_request_body
  request_headers = {
    "Content-Type"    = "application/json"
    "Accept-Language" = "en-us"
    "x-sr-ubid"       = local.sign_in.ubid
    "x-sr-token"      = local.sign_in.token
    "x-sr-nonce"      = random_uuid.celerdata_save_storage_nonce.result
    "x-sr-timestamp"  = time_static.celerdata_save_storage_timestamp.unix * 1000
    "x-sr-signature" = sha256(join("", [
      local.sign_in.ubid,
      local.sign_in.token,
      random_uuid.celerdata_save_storage_nonce.result,
      time_static.celerdata_save_storage_timestamp.unix * 1000,
      local.create_storage_config_request_body
    ]))
  }
}

resource "random_password" "celerdata_cluster_initial_admin_password" {
  length           = 12
  upper            = true
  lower            = true
  numeric          = true
  special          = true
  override_special = "!@#$%^&*_"
  keepers = {
    random_id = uuid()
  }
}

locals {
  storage_config_response     = jsondecode(data.http.create_storage_config.response_body)
  storage_conf_id             = local.storage_config_response.data == null ? "" : local.storage_config_response.data.storageConfigId
  deploy_cluster_request_body = jsonencode({
    cluster_name          = var.celerdata_cluster_name
    credential_id         = local.credential_id
    net_iface_id          = local.net_iface_id
    storage_conf_id       = local.storage_conf_id
    admin_password        = random_password.celerdata_cluster_initial_admin_password.result
    ssl_connection_enable = true
    quickStartUUID        = local.sign_in.quickStartUUID
  })
}

resource "random_uuid" "celerdata_save_cluster_nonce" {}
resource "time_static" "celerdata_save_cluster_timestamp" {
  triggers = {
    refresh = timestamp()
  }
}

data "http" "deploy_cluster" {
  url    = "https://${var.celerdata_cloud_api_host}/api/quickstart/deploy-cluster"
  method = "POST"
  request_body = local.deploy_cluster_request_body
  request_headers = {
    "Content-Type"    = "application/json"
    "Accept-Language" = "en-us"
    "x-sr-ubid"       = local.sign_in.ubid
    "x-sr-token"      = local.sign_in.token
    "x-sr-nonce"      = random_uuid.celerdata_save_cluster_nonce.result
    "x-sr-timestamp"  = time_static.celerdata_save_cluster_timestamp.unix * 1000
    "x-sr-signature" = sha256(join("", [
      local.sign_in.ubid,
      local.sign_in.token,
      random_uuid.celerdata_save_cluster_nonce.result,
      time_static.celerdata_save_cluster_timestamp.unix * 1000,
      local.deploy_cluster_request_body
    ]))
  }
}

locals {
  deploy_cluster_response = jsondecode(data.http.deploy_cluster.response_body)
  order_id                = local.deploy_cluster_response.data == null ? "" : local.deploy_cluster_response.data.orderId
  csp_id                  = local.deploy_cluster_response.data == null ? "" : local.deploy_cluster_response.data.cspId
}
