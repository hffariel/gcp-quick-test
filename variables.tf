variable "project_id" {
  description = "The GCP project ID where celerdata resources will be created."
  type        = string
}

variable "region" {
  description = "The GCP region where celerdata resources will be created."
  type        = string
}

variable "celerdata_cluster_name" {
  description = "The name of the celerdata cluster to be deployed."
  type        = string
}

variable "celerdata_service_account_email" {
  description = "The email of the celerdata service account."
  type        = string
}

