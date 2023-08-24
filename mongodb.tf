locals {
  mongodb_connection_options = "retryWrites=true&w=majority"
}

resource "mongodbatlas_project_ip_access_list" "main" {
  project_id = var.mongodb_atlas_project_id
  comment    = "See https://relaycorp.atlassian.net/browse/LTR-70"
  cidr_block = "0.0.0.0/0"
}
