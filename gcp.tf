locals {
  services = [
    "run.googleapis.com",
    "compute.googleapis.com",
    "cloudkms.googleapis.com",
    "pubsub.googleapis.com",
    "secretmanager.googleapis.com",
    "iam.googleapis.com",
    "cloudscheduler.googleapis.com",
    "identitytoolkit.googleapis.com",
  ]
}

resource "google_project_service" "services" {
  for_each = toset(local.services)

  project                    = var.google_project_id
  service                    = each.value
  disable_dependent_services = true
}

resource "time_sleep" "wait_for_services" {
  depends_on      = [google_project_service.services]
  create_duration = "30s"
}

data "google_project" "main" {
  project_id = var.google_project_id
}

resource "google_project_iam_member" "project_viewer" {
  project = var.google_project_id

  role   = "roles/viewer"
  member = var.sre_iam_uri
}
