resource "google_billing_budget" "main" {
  billing_account = var.google_billing_account_id
  display_name    = "${data.google_project.main.project_id} (TFE workspace ${terraform.workspace})"

  budget_filter {
    projects = ["projects/${data.google_project.main.number}"]
  }

  amount {
    specified_amount {
      units         = var.google_monthly_budget_usd
      currency_code = "USD"
    }
  }

  threshold_rules {
    threshold_percent = 0.9
  }
  threshold_rules {
    threshold_percent = 1.0
    spend_basis       = "FORECASTED_SPEND"
  }

  all_updates_rule {
    monitoring_notification_channels = [for channel in google_monitoring_notification_channel.sres_email : channel.name]
    disable_default_iam_recipients   = true
  }

  depends_on = [google_project_service.services]
}

resource "mongodbatlas_alert_configuration" "billing" {
  project_id = var.mongodb_atlas_project_id
  event_type = "PENDING_INVOICE_OVER_THRESHOLD"
  enabled    = true

  metric_threshold_config {
    operator  = "GREATER_THAN"
    threshold = var.mongodb_monthly_budget_usd
    units     = "RAW"
  }

  notification {
    type_name     = "ORG"
    interval_min  = 120
    delay_min     = 0
    sms_enabled   = false
    email_enabled = true
    roles         = ["ORG_BILLING_ADMIN"]
  }
}
