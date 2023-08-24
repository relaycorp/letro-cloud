# ===== Incoming messages

resource "google_service_account" "letro_invoker" {
  project = var.google_project_id

  account_id   = "letro-pubsub"
  display_name = "Letro, Cloud Run service invoker"
}

resource "google_cloud_run_service_iam_binding" "letro_invoker" {
  project = var.google_project_id

  location = google_cloud_run_v2_service.letro.location
  service  = google_cloud_run_v2_service.letro.name
  role     = "roles/run.invoker"
  members  = ["serviceAccount:${google_service_account.letro_invoker.email}"]
}

resource "google_pubsub_subscription" "letro_incoming_messages" {
  project = var.google_project_id

  name  = "letro.incoming-messages"
  topic = module.endpoint.pubsub_topics.incoming_messages

  filter = "hasPrefix(attributes.datacontenttype, \"application/vnd.relaycorp.letro.\")"

  ack_deadline_seconds       = 10
  message_retention_duration = "259200s" # 3 days
  retain_acked_messages      = false
  expiration_policy {
    ttl = "" # Never expire
  }

  push_config {
    push_endpoint = google_cloud_run_v2_service.letro.uri
    oidc_token {
      service_account_email = google_service_account.letro_invoker.email
    }
    attributes = {
      x-goog-version = "v1"
    }
  }

  retry_policy {
    minimum_backoff = "5s"
  }
}

# ===== Outgoing messages

resource "google_pubsub_topic_iam_binding" "letro_outgoing_messages_publisher" {
  project = var.google_project_id

  topic   = module.endpoint.pubsub_topics.outgoing_messages
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${google_service_account.letro.email}", ]
}
