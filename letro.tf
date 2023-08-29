locals {
  letro_db_name = "letro"
}

resource "google_cloud_run_v2_service" "letro" {
  name     = "letro"
  location = var.google_region
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  template {
    timeout = "3s"

    service_account = google_service_account.letro.email

    execution_environment = "EXECUTION_ENVIRONMENT_GEN2"

    max_instance_request_concurrency = var.letro_max_instance_request_concurrency

    containers {
      name  = "letro"
      image = "${var.letro_docker_image_name}:${var.letro_docker_image_tag}"

      env {
        name  = "VERSION"
        value = var.letro_docker_image_tag
      }

      env {
        name  = "MONGODB_URI"
        value = "${mongodbatlas_serverless_instance.letro.connection_strings_standard_srv}/?${local.mongodb_connection_options}"
      }
      env {
        name  = "MONGODB_DB"
        value = local.letro_db_name
      }
      env {
        name  = "MONGODB_USER"
        value = mongodbatlas_database_user.letro.username
      }
      env {
        name = "MONGODB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.letro_mongodb_password.id
            version = "latest"
          }
        }
      }

      env {
        name  = "CE_TRANSPORT"
        value = "google-pubsub"
      }
      env {
        name  = "CE_GPUBSUB_TOPIC"
        value = module.endpoint.pubsub_topics.outgoing_messages
      }

      env {
        name  = "LOG_LEVEL"
        value = var.letro_log_level
      }
      env {
        name  = "LOG_TARGET"
        value = "gcp"
      }

      env {
        name  = "REQUEST_ID_HEADER"
        value = "X-Cloud-Trace-Context"
      }

      resources {
        startup_cpu_boost = true
        cpu_idle          = false

        limits = {
          cpu    = 1
          memory = "512Mi"
        }
      }

      startup_probe {
        initial_delay_seconds = 3
        failure_threshold     = 3
        period_seconds        = 10
        timeout_seconds       = 3
        http_get {
          path = "/"
          port = 8080
        }
      }

      liveness_probe {
        initial_delay_seconds = 0
        failure_threshold     = 3
        period_seconds        = 20
        timeout_seconds       = 3
        http_get {
          path = "/"
          port = 8080
        }
      }
    }

    scaling {
      min_instance_count = var.letro_min_instance_count
      max_instance_count = var.letro_max_instance_count
    }
  }

  depends_on = [
    google_secret_manager_secret_iam_binding.letro_mongodb_password_reader,
  ]
}

resource "google_service_account" "letro" {
  project = var.google_project_id

  account_id   = "letro-server"
  display_name = "Letro server"
}
