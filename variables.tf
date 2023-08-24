variable "google_project_id" {}
variable "google_region" {}
variable "google_billing_account_id" {}
variable "google_monthly_budget_usd" {}

variable "mongodb_atlas_project_id" {}
variable "mongodb_atlas_region" {}

variable "sre_iam_uri" {
  description = "GCP IAM URI for an SRE or the SRE group (e.g., 'group:sre-team@acme.com')"
}
variable "sre_email_addresses" {
  description = "Email address for each SRE at Relaycorp"
  type        = list(string)
}


# ===== VeraId Authority

variable "veraid_authority_docker_image_tag" {
  description = "The Docker image tag for the VeraId Authority"
}
variable "veraid_authority_api_auth_audience" {
  description = "The OAuth2 audience"
  type        = string
}
variable "veraid_authority_api_superadmin_sub" {
  description = "The sub claim from the JWTs of the superadmin"
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
