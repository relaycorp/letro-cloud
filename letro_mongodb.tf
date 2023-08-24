resource "mongodbatlas_serverless_instance" "letro" {
  project_id = var.mongodb_atlas_project_id
  name       = "letro"

  provider_settings_backing_provider_name = "GCP"
  provider_settings_provider_name         = "SERVERLESS"
  provider_settings_region_name           = var.mongodb_atlas_region

  termination_protection_enabled = true
}

resource "mongodbatlas_database_user" "letro" {
  project_id = var.mongodb_atlas_project_id

  username           = "letro"
  password           = random_password.letro_mongodb_user_password.result
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = local.letro_db_name
  }
}

resource "random_password" "letro_mongodb_user_password" {
  length = 32
}

resource "google_secret_manager_secret" "letro_mongodb_password" {
  project = var.google_project_id

  secret_id = "letro_mongodb-password"

  replication {
    user_managed {
      replicas {
        location = var.google_region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "letro_mongodb_password" {
  secret      = google_secret_manager_secret.letro_mongodb_password.id
  secret_data = random_password.letro_mongodb_user_password.result
}

resource "google_secret_manager_secret_iam_binding" "letro_mongodb_password_reader" {
  secret_id = google_secret_manager_secret.letro_mongodb_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members   = ["serviceAccount:${google_service_account.letro.email}"]
}
