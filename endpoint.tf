locals {
  endpoint_db_name = "awala-endpoint"
}

module "endpoint" {
  source  = "relaycorp/awala-endpoint/google"
  version = "1.8.25"

  backend_name     = local.instance_name
  internet_address = var.awala_endpoint_internet_address

  docker_image_tag = var.awala_endpoint_docker_image_tag

  project_id = var.google_project_id
  region     = var.google_region

  kms_protection_level = "HSM"

  pohttp_server_domain = var.awala_endpoint_pohttp_domain

  pohttp_client_min_instance_count = var.awala_endpoint_client_min_instance_count

  mongodb_uri      = "${mongodbatlas_serverless_instance.endpoint.connection_strings_standard_srv}/?${local.mongodb_connection_options}"
  mongodb_db       = local.endpoint_db_name
  mongodb_user     = mongodbatlas_database_user.endpoint.username
  mongodb_password = random_password.mongodb_endpoint_user_password.result

  depends_on = [time_sleep.wait_for_services]
}

resource "google_cloud_run_v2_job_iam_binding" "endpoint_bootstrap_invoker" {
  project = var.google_project_id

  location = var.google_region
  name     = module.endpoint.bootstrap_job_name
  role     = "roles/run.invoker"
  members  = [var.sre_iam_uri]
}

resource "mongodbatlas_serverless_instance" "endpoint" {
  project_id = var.mongodb_atlas_project_id
  name       = "awala-endpoint"

  provider_settings_backing_provider_name = "GCP"
  provider_settings_provider_name         = "SERVERLESS"
  provider_settings_region_name           = var.mongodb_atlas_region

  termination_protection_enabled = true
}

resource "mongodbatlas_database_user" "endpoint" {
  project_id = var.mongodb_atlas_project_id

  username           = "awala-endpoint"
  password           = random_password.mongodb_endpoint_user_password.result
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = local.endpoint_db_name
  }
}

resource "random_password" "mongodb_endpoint_user_password" {
  length = 32
}
