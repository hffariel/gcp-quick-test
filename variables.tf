variable "project_id" {
  description = "The GCP project where celerdata resources will be created."
  type        = string
  default     = ""
}

variable "region" {
  description = "The GCP region where celerdata resources will be created."
  type        = string
  default     = ""
}

variable "celerdata_cluster_name" {
  description = "The name of the celerdata cluster to be deployed."
  type        = string
}

variable "celerdata_service_account_email" {
  description = "The email of the celerdata service account."
  type        = string
}

variable "celerdata_cloud_api_host" {
  description = "The cloud api service host of CelerData"
  type        = string
  default     = "cloud-api.celerdata.com"
}

variable "celerdata_cloud_api_credential" {
  description = "The temporary credentials used to create a celerdata cluster."
  type        = string
}
