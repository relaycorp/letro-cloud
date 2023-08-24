locals {
  authority_db_name = "veraid-authority"
}

module "authority" {
  source  = "relaycorp/veraid-authority/google"
  version = "1.2.2"

  instance_name = local.instance_name

  project_id = var.google_project_id
  region     = var.google_region

  mongodb_uri      = "${mongodbatlas_serverless_instance.authority.connection_strings_standard_srv}/?${local.mongodb_connection_options}"
  mongodb_db       = local.authority_db_name
  mongodb_user     = mongodbatlas_database_user.authority.username
  mongodb_password = random_password.mongodb_authority_user_password.result

  api_auth_audience = var.veraid_authority_api_auth_audience
  superadmin_sub    = var.veraid_authority_api_superadmin_sub

  awala_endpoint_enabled                 = true
  awala_endpoint_incoming_messages_topic = module.endpoint.pubsub_topics.incoming_messages
  awala_endpoint_outgoing_messages_topic = module.endpoint.pubsub_topics.outgoing_messages

  depends_on = [time_sleep.wait_for_services]
}

# ===== MongoDB

resource "mongodbatlas_serverless_instance" "authority" {
  project_id = var.mongodb_atlas_project_id
  name       = "veraid-authority"

  provider_settings_backing_provider_name = "GCP"
  provider_settings_provider_name         = "SERVERLESS"
  provider_settings_region_name           = var.mongodb_atlas_region

  termination_protection_enabled = true
}

resource "mongodbatlas_database_user" "authority" {
  project_id = var.mongodb_atlas_project_id

  username           = "veraid-authority"
  password           = random_password.mongodb_authority_user_password.result
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = local.authority_db_name
  }
}

resource "random_password" "mongodb_authority_user_password" {
  length = 32
}
