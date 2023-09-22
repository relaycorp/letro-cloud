variable "google_project_id" {}
variable "google_region" {}
variable "google_billing_account_id" {}
variable "google_monthly_budget_usd" {}

variable "mongodb_atlas_project_id" {}
variable "mongodb_atlas_region" {}
variable "mongodb_monthly_budget_usd" {}

variable "sre_iam_uri" {
  description = "GCP IAM URI for an SRE or the SRE group (e.g., 'group:sre-team@acme.com')"
}
variable "sre_email_addresses" {
  description = "Email address for each SRE at Relaycorp"
  type        = list(string)
}
variable "superadmin_email_address" {
  description = "Email address for the superadmin"
}

# ===== Letro

variable "letro_docker_image_name" {
  description = "The Docker image name for the Letro server"
  default     = "relaycorp/letro"
}
variable "letro_docker_image_tag" {
  description = "The Docker image tag for the Letro server"
}

variable "letro_log_level" {
  description = "The log level for the Letro server"
  default     = "info"
}

variable "letro_max_instance_request_concurrency" {
  description = "The maximum number of concurrent requests per instance"
  default     = 100
}
variable "letro_min_instance_count" {
  description = "The minimum number of Letro instances"
}
variable "letro_max_instance_count" {
  description = "The maximum number of Letro instances"
}

# ===== VeraId Authority

variable "veraid_authority_docker_image_tag" {
  description = "The Docker image tag for the VeraId Authority"
}
variable "veraid_authority_api_auth_audience" {
  description = "The OAuth2 audience"
  type        = string
}
variable "veraid_authority_awala_backend_min_instance_count" {
  description = "The minimum number of Awala backend instances from VeraId Authority"
}
variable "veraid_authority_queue_min_instance_count" {
  description = "The minimum number of queue instances from VeraId Authority"
}

# ===== Awala Internet Endpoint

variable "awala_endpoint_docker_image_tag" {
  description = "The Docker image tag for the Awala Internet Endpoint"
}
variable "awala_endpoint_internet_address" {
  description = "The Internet address for the Awala Internet Endpoint"
}
variable "awala_endpoint_pohttp_domain" {
  description = "The domain name for the PoHTTP server in the Awala Internet Endpoint"
}
variable "awala_endpoint_client_min_instance_count" {
  description = "The minimum number of Awala Internet Endpoint client instances"
}
